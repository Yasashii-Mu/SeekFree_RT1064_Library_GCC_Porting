#!/bin/sh
if [ -z "${ARMGCC_DIR:-}" ]; then
    if ! command -v arm-none-eabi-gcc >/dev/null 2>&1; then
        echo "找不到 arm-none-eabi-gcc，请安装 gcc-arm-none-eabi 或设置 ARMGCC_DIR。" >&2
        return 1
    fi
    ARMGCC_DIR=$(dirname "$(dirname "$(command -v arm-none-eabi-gcc)")")
fi
export ARMGCC_DIR
