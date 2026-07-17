#!/bin/bash
# =============================================================================
# benchmark.sh -- LLM Benchmarking Suite
# =============================================================================
# Runs standardized benchmarks on GGUF models using llama.cpp's llama-bench.
# Supports multiple models, quants, and configurations in batch.
#
# Usage:
#   ./benchmark.sh --models ./models/*.gguf
#   ./benchmark.sh --model ./my-model.gguf --prompt 512 --gen 256
#
# Dependencies: llama.cpp built with llama-bench executable
# =============================================================================

set -euo pipefail

# ---- Configuration ----------------------------------------------------------
LLAMACPP_DIR="${LLAMACPP_DIR:-./llama.cpp}"
BENCH_BIN="${LLAMACPP_DIR}/llama-bench"
[[ ! -f "${BENCH_BIN}" ]] && BENCH_BIN="${LLAMACPP_DIR}/build/bin/llama-bench"

OUTPUT_DIR="${OUTPUT_DIR:-./benchmark-results}"
PROMPT_LEN="${PROMPT_LEN:-512}"
GEN_LEN="${GEN_LEN:-256}"
THREADS="${THREADS:-$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 8)}"
GPU_LAYERS="${GPU_LAYERS:-99}"
ITERATIONS="${ITERATIONS:-3}"

# ---- Helper Functions -------------------------------------------------------
usage() {
    cat <<EOF
Usage: $(basename "$0") (--model <file> | --models <glob>) [options]

Options:
  --model, -m        Single GGUF model file to benchmark
  --models, -M       Glob pattern for multiple models (e.g., "./models/*.gguf")
  --prompt, -p       Prompt length in tokens (default: ${PROMPT_LEN})
  --gen, -g          Generation length in tokens (default: ${GEN_LEN})
  --threads, -t      Number of CPU threads (default: ${THREADS})
  --gpu-layers, -ngl GPU layers to offload (default: ${GPU_LAYERS})
  --iterations, -i   Number of benchmark runs (default: ${ITERATIONS})
  --output, -o       Output directory (default: ${OUTPUT_DIR})
  --help, -h         Show this help
EOF
    exit 1
}

log()   { echo "[INFO]  $*"; }
warn()  { echo "[WARN]  $*" >&2; }
error() { echo "[ERROR] $*" >&2; exit 1; }

# ---- Parse Arguments --------------------------------------------------------
MODEL_FILE=""
MODELS_GLOB=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --model|-m)       MODEL_FILE="$2"; shift 2 ;;
        --models|-M)      MODELS_GLOB="$2"; shift 2 ;;
        --prompt|-p)      PROMPT_LEN="$2"; shift 2 ;;
        --gen|-g)         GEN_LEN="$2"; shift 2 ;;
        --threads|-t)     THREADS="$2"; shift 2 ;;
        --gpu-layers|-ngl) GPU_LAYERS="$2"; shift 2 ;;
        --iterations|-i)  ITERATIONS="$2"; shift 2 ;;
        --output|-o)      OUTPUT_DIR="$2"; shift 2 ;;
        --help|-h)        usage ;;
        *)                error "Unknown argument: $1" ;;
    esac
done

[[ -z "${MODEL_FILE}" && -z "${MODELS_GLOB}" ]] && error "Specify --model or --models"
[[ -z "${BENCH_BIN}" || ! -x "${BENCH_BIN}" ]] && error "llama-bench not found. Build llama.cpp first."

mkdir -p "${OUTPUT_DIR}"
RESULTS_CSV="${OUTPUT_DIR}/benchmark-results-$(date +%Y%m%d-%H%M%S).csv"

# ---- Collect Model Files ----------------------------------------------------
MODEL_FILES=()
if [[ -n "${MODEL_FILE}" ]]; then
    [[ ! -f "${MODEL_FILE}" ]] && error "Model file not found: ${MODEL_FILE}"
    MODEL_FILES+=("${MODEL_FILE}")
fi
if [[ -n "${MODELS_GLOB}" ]]; then
    for f in ${MODELS_GLOB}; do
        [[ -f "${f}" ]] && MODEL_FILES+=("${f}")
    done
fi

[[ ${#MODEL_FILES[@]} -eq 0 ]] && error "No model files found"

# ---- Write CSV Header -------------------------------------------------------
echo "model,quant,file_size_gb,prompt_len,gen_len,threads,gpu_layers,prompt_ts,gen_ts,load_time_s" > "${RESULTS_CSV}"

# ---- Benchmark Loop ---------------------------------------------------------
for MODEL in "${MODEL_FILES[@]}"; do
    MODEL_BASENAME=$(basename "${MODEL}")
    MODEL_DIR=$(dirname "${MODEL}")
    MODEL_SIZE=$(ls -lh "${MODEL}" | awk '{print $5}')

    log "Benchmarking: ${MODEL_BASENAME} (${MODEL_SIZE})"

    for ((i=1; i<=ITERATIONS; i++)); do
        log "  Run ${i}/${ITERATIONS}..."

        # Extract quant type from filename (e.g., model-q4_k_m.gguf -> q4_k_m)
        QUANT=""
        if [[ "${MODEL_BASENAME}" =~ -([qQ][0-9I][_a-zA-Z0-9]+)\.gguf ]]; then
            QUANT="${BASH_REMATCH[1]}"
        fi

        OUTPUT=$("${BENCH_BIN}" \
            -m "${MODEL}" \
            -p "${PROMPT_LEN}" \
            -n "${GEN_LEN}" \
            -t "${THREADS}" \
            -ngl "${GPU_LAYERS}" \
            --output-format csv \
            2>/dev/null || echo "")

        if [[ -z "${OUTPUT}" ]]; then
            warn "    llama-bench returned empty output, checking alternative flags..."
            OUTPUT=$("${BENCH_BIN}" \
                -m "${MODEL}" \
                -p "${PROMPT_LEN}" \
                -n "${GEN_LEN}" \
                -t "${THREADS}" \
                -ngl "${GPU_LAYERS}" \
                2>&1 | grep -E "^[0-9]")

            if [[ -z "${OUTPUT}" ]]; then
                warn "    Skipping ${MODEL_BASENAME} (llama-bench failed)"
                continue
            fi

            # Parse human-readable output
            PROMPT_T=$(echo "${OUTPUT}" | awk '{print $5}')
            GEN_T=$(echo "${OUTPUT}" | awk '{print $7}')
            LOAD_T=$(echo "${OUTPUT}" | awk '{print $3}')
            echo "${MODEL_BASENAME},${QUANT},${MODEL_SIZE},${PROMPT_LEN},${GEN_LEN},${THREADS},${GPU_LAYERS},${PROMPT_T},${GEN_T},${LOAD_T}" >> "${RESULTS_CSV}"
        else
            echo "${OUTPUT}" >> "${RESULTS_CSV}"
        fi
    done
done

# ---- Summary ----------------------------------------------------------------
log "=========================================="
log "Benchmarking complete!"
log "Results: ${RESULTS_CSV}"
log ""
log "Summary:"
awk -F',' 'NR>1 {
    model=$1; gen=$9
    if(gen ~ /^[0-9.]+$/) {
        sum[model]+=gen; count[model]++
    }
} END {
    for(m in sum) printf "  %-50s %.1f t/s (avg)\n", m, sum[m]/count[m]
}' "${RESULTS_CSV}" 2>/dev/null || true
log "=========================================="
