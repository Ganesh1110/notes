#!/bin/bash
# =============================================================================
# quantize.sh -- GGUF Model Quantization Script
# =============================================================================
# Automates the process of converting Hugging Face models to GGUF and
# quantizing them to multiple precision levels.
#
# Usage:
#   ./quantize.sh --model /path/to/hf-model [options]
#   ./quantize.sh --model meta-llama/Llama-3.1-8B --quants "q4_k_m,q5_k_m,q8_0"
#
# Dependencies: python3, cmake, make, git, huggingface-cli
# =============================================================================

set -euo pipefail

# ---- Configuration ----------------------------------------------------------
LLAMACPP_DIR="${LLAMACPP_DIR:-./llama.cpp}"
OUTPUT_DIR="${OUTPUT_DIR:-./models}"
QUANTS_DEFAULT="q4_k_m,q5_k_m,q8_0"
CONVERT_SCRIPT=""
QUANTIZE_BIN=""
JOBS=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

# ---- Helper Functions -------------------------------------------------------
usage() {
    cat <<EOF
Usage: $(basename "$0") --model <path|hf-repo> [options]

Required:
  --model, -m        Model path (local directory) or Hugging Face repo ID

Options:
  --quants, -q       Comma-separated quant types (default: ${QUANTS_DEFAULT})
  --output, -o       Output directory (default: ${OUTPUT_DIR})
  --llamacpp, -l     Path to llama.cpp directory (default: ${LLAMACPP_DIR})
  --name, -n         Custom model name (default: derived from model path)
  --no-download      Skip HF download (assume local path)
  --keep-f16         Keep the FP16 GGUF file
  --help, -h         Show this help message

Examples:
  ./quantize.sh -m ./my-model --quants "q4_k_m,q6_k"
  ./quantize.sh -m meta-llama/Llama-3.1-8B -n llama-3.1-8b
  ./quantize.sh -m ./qwen2.5-7b --no-download --keep-f16
EOF
    exit 1
}

log()  { echo "[INFO]  $*"; }
warn() { echo "[WARN]  $*" >&2; }
error(){ echo "[ERROR] $*" >&2; exit 1; }

# ---- Parse Arguments --------------------------------------------------------
MODEL=""
QUANTS="${QUANTS_DEFAULT}"
MODEL_NAME=""
DOWNLOAD=true
KEEP_F16=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --model|-m)       MODEL="$2"; shift 2 ;;
        --quants|-q)      QUANTS="$2"; shift 2 ;;
        --output|-o)      OUTPUT_DIR="$2"; shift 2 ;;
        --llamacpp|-l)    LLAMACPP_DIR="$2"; shift 2 ;;
        --name|-n)        MODEL_NAME="$2"; shift 2 ;;
        --no-download)    DOWNLOAD=false; shift ;;
        --keep-f16)       KEEP_F16=true; shift ;;
        --help|-h)        usage ;;
        *)                error "Unknown argument: $1" ;;
    esac
done

[[ -z "${MODEL}" ]] && error "Missing required argument: --model"

# ---- Setup -------------------------------------------------------------------
mkdir -p "${OUTPUT_DIR}"

# Find llama.cpp tools
if [[ -d "${LLAMACPP_DIR}" ]]; then
    CONVERT_SCRIPT="${LLAMACPP_DIR}/convert_hf_to_gguf.py"
    [[ ! -f "${CONVERT_SCRIPT}" ]] && CONVERT_SCRIPT="${LLAMACPP_DIR}/convert.py"
    QUANTIZE_BIN="${LLAMACPP_DIR}/llama-quantize"
    [[ ! -f "${QUANTIZE_BIN}" ]] && QUANTIZE_BIN="${LLAMACPP_DIR}/quantize"
else
    error "llama.cpp directory not found at ${LLAMACPP_DIR}. Set --llamacpp or LLAMACPP_DIR."
fi

[[ ! -f "${CONVERT_SCRIPT}" ]] && error "convert script not found in ${LLAMACPP_DIR}"
[[ ! -x "${QUANTIZE_BIN}" ]]   && error "quantize binary not found or not executable in ${LLAMACPP_DIR}"

# ---- Download Model (if needed) ----------------------------------------------
if [[ "${DOWNLOAD}" == true ]]; then
    log "Downloading model from Hugging Face: ${MODEL}"
    export HF_HUB_ENABLE_HF_TRANSFER=1
    MODEL_PATH="${OUTPUT_DIR}/models/$(basename "${MODEL}")"
    mkdir -p "${MODEL_PATH}"
    huggingface-cli download "${MODEL}" --local-dir "${MODEL_PATH}" --local-dir-use-symlinks False
    # Ensure LFS files are pulled
    (cd "${MODEL_PATH}" && git lfs pull 2>/dev/null || true)
else
    MODEL_PATH="${MODEL}"
fi

[[ ! -d "${MODEL_PATH}" ]] && error "Model directory not found: ${MODEL_PATH}"

# ---- Determine Model Name ----------------------------------------------------
if [[ -z "${MODEL_NAME}" ]]; then
    MODEL_NAME=$(basename "${MODEL_PATH}" | tr '[:upper:]' '[:lower:]' | tr '.' '-')
fi

log "Model:      ${MODEL_NAME}"
log "Model path: ${MODEL_PATH}"
log "Output:     ${OUTPUT_DIR}"

# ---- Step 1: Convert to FP16 GGUF -------------------------------------------
FP16_GGUF="${OUTPUT_DIR}/${MODEL_NAME}-f16.gguf"

if [[ ! -f "${FP16_GGUF}" ]]; then
    log "Converting to FP16 GGUF..."
    python3 "${CONVERT_SCRIPT}" "${MODEL_PATH}" \
        --outfile "${FP16_GGUF}" \
        --outtype f16 \
        --model-name "${MODEL_NAME}"
    log "FP16 GGUF created: ${FP16_GGUF}"
else
    log "FP16 GGUF already exists: ${FP16_GGUF}"
fi

# ---- Step 2: Quantize --------------------------------------------------------
IFS=',' read -ra QUANT_LIST <<< "${QUANTS}"

for QUANT in "${QUANT_LIST[@]}"; do
    QUANT_TRIMMED=$(echo "${QUANT}" | xargs)
    [[ -z "${QUANT_TRIMMED}" ]] && continue

    OUTPUT_GGUF="${OUTPUT_DIR}/${MODEL_NAME}-${QUANT_TRIMMED}.gguf"

    if [[ -f "${OUTPUT_GGUF}" ]]; then
        log "Quant ${QUANT_TRIMMED} already exists, skipping: ${OUTPUT_GGUF}"
        continue
    fi

    log "Quantizing to ${QUANT_TRIMMED}..."
    "${QUANTIZE_BIN}" "${FP16_GGUF}" "${OUTPUT_GGUF}" "${QUANT_TRIMMED}"
    log "Created: ${OUTPUT_GGUF}"
done

# ---- Step 3: Cleanup ---------------------------------------------------------
if [[ "${KEEP_F16}" == false ]]; then
    log "Removing FP16 GGUF (use --keep-f16 to retain)..."
    rm -f "${FP16_GGUF}"
fi

# ---- Summary --------------------------------------------------------
log "=========================================="
log "Quantization complete!"
log "Output directory: ${OUTPUT_DIR}"
log "Files:"
ls -lh "${OUTPUT_DIR}/${MODEL_NAME}"-*.gguf 2>/dev/null || true
log "=========================================="
