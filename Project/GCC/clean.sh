#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
rm -rf -- build debug release CMakeFiles
rm -f -- output.map build_log.txt Makefile cmake_install.cmake CMakeCache.txt
