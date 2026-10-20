#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
source "$SCRIPT_DIR/env.sh"

cmake -S "$SCRIPT_DIR" -B "$SCRIPT_DIR/build" \
    -DCMAKE_TOOLCHAIN_FILE="$SCRIPT_DIR/armgcc.cmake" \
    -DCMAKE_BUILD_TYPE=debug \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

cmake --build "$SCRIPT_DIR/build" --parallel "${BUILD_JOBS:-$(nproc)}" "$@" \
    2>&1 | tee "$SCRIPT_DIR/build_log.txt"
