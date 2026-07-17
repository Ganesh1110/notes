#!/bin/bash
# =============================================================================
# convert.sh -- Hugging Face to GGUF Converter
# =============================================================================
# Converts any Hugging Face model to GGUF format using llama.cpp.
# Supports downloading from HF Hub or converting local models.
#
# Usage:
#   ./convert.sh --hf meta-llama/Llama-3.1-8B
#   ./convert.sh --local ./my-model-directory --outtype f16
#
# Dependencies: python3, huggingface-cli (optional for HF downloads)
# =============================================================================

set -euo pipefail

# ---- Default Configuration --------------------------------------------------
LLAMACPP_DIR="${LLAMACPP_DIR:-./llama.cpp}"
OUTTYPE="${OUTTYPE:-f16}"
OUTPUT_DIR="${OUTPUT_DIR:-./models}"
JOBS=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

# ---- Helper Functions -------------------------------------------------------
usage() {
    cat <<EOF
Usage: $(basename "$0") (--hf <repo> | --local <path>) [options]

Options:
  --hf <repo>          Hugging Face repository ID (e.g., meta-llama/Llama-3.1-8B)
  --local <path>       Path to local model directory
  --outtype <type>     Output type: f16 (default), f32, q8_0
  --output <dir>       Output directory (default: ${OUTPUT_DIR})
  --llamacpp <dir>     llama.cpp directory (default: ${LLAMACPP_DIR})
  --name <name>        Custom model name (default: basename of model path)
  --no-tokenizer       Skip tokenizer conversion
  --pad-vocab <N>      Pad vocabulary to multiple of N
  --verbose            Enable verbose output
  --help, -h           Show this help
EOF
    exit 1
}

log()  { echo "[INFO]  $*"; }
warn() { echo "[WARN]  $*" >&2; }
error(){ echo "[ERROR] $*" >&2; exit 1; }

# ---- Parse Arguments --------------------------------------------------------
HF_REPO=""
LOCAL_PATH=""
OUTTYPE="f16"
MODEL_NAME=""
EXTRA_ARGS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --hf)             HF_REPO="$2"; shift 2 ;;
        --local)          LOCAL_PATH="$2"; shift 2 ;;
        --outtype)        OUTTYPE="$2"; shift 2 ;;
        --output)         OUTPUT_DIR="$2"; shift 2 ;;
        --llamacpp)       LLAMACPP_DIR="$2"; shift 2 ;;
        --name)           MODEL_NAME="$2"; shift 2 ;;
        --no-tokenizer)   EXTRA_ARGS+=("--no-tokenizer"); shift ;;
        --pad-vocab)      EXTRA_ARGS+=("--pad-vocab" "$2"); shift 2 ;;
        --verbose)        EXTRA_ARGS+=("--verbose"); shift ;;
        --help|-h)        usage ;;
        *)                error "Unknown argument: $1" ;;
    esac
done

# ---- Validate Arguments -----------------------------------------------------
[[ -z "${HF_REPO}" && -z "${LOCAL_PATH}" ]] && error "Specify --hf or --local"
[[ -n "${HF_REPO}" && -n "${LOCAL_PATH}" ]] && error "Specify only one of --hf or --local"

# ---- Setup -------------------------------------------------------------------
mkdir -p "${OUTPUT_DIR}"

# Find convert script
CONVERT_SCRIPT="${LLAMACPP_DIR}/convert_hf_to_gguf.py"
[[ ! -f "${CONVERT_SCRIPT}" ]] && CONVERT_SCRIPT="${LLAMACPP_DIR}/convert.py"
[[ ! -f "${CONVERT_SCRIPT}" ]] && error "convert script not found in ${LLAMACPP_DIR}. Try: git clone https://github.com/ggerganov/llama.cpp"

# ---- Download or Use Local Path ---------------------------------------------
if [[ -n "${HF_REPO}" ]]; then
    log "Downloading from Hugging Face: ${HF_REPO}"
    export HF_HUB_ENABLE_HF_TRANSFER=1
    MODEL_PATH="${OUTPUT_DIR}/models/$(echo "${HF_REPO}" | tr '/' '-')"
    mkdir -p "${MODEL_PATH}"
    huggingface-cli download "${HF_REPO}" --local-dir "${MODEL_PATH}" --local-dir-use-symlinks False
    (cd "${MODEL_PATH}" && git lfs pull 2>/dev/null || true)

    [[ -z "${MODEL_NAME}" ]] && MODEL_NAME=$(basename "${HF_REPO}" | tr '[:upper:]' '[:lower:]')
else
    MODEL_PATH="${LOCAL_PATH}"
    [[ -z "${MODEL_NAME}" ]] && MODEL_NAME=$(basename "${LOCAL_PATH}" | tr '[:upper:]' '[:lower:]')
fi

[[ ! -d "${MODEL_PATH}" ]] && error "Model directory not found: ${MODEL_PATH}"

# ---- Convert to GGUF --------------------------------------------------------
OUTPUT_GGUF="${OUTPUT_DIR}/${MODEL_NAME}-${OUTTYPE}.gguf"

log "Converting ${MODEL_PATH} -> ${OUTPUT_GGUF} (${OUTTYPE})"
log "Using convert script: ${CONVERT_SCRIPT}"

python3 "${CONVERT_SCRIPT}" \
    "${MODEL_PATH}" \
    --outfile "${OUTPUT_GGUF}" \
    --outtype "${OUTTYPE}" \
    --model-name "${MODEL_NAME}" \
    "${EXTRA_ARGS[@]}"

log "=========================================="
log "Conversion complete!"
log "Output: ${OUTPUT_GGUF}"
ls -lh "${OUTPUT_GGUF}"
log "=========================================="
