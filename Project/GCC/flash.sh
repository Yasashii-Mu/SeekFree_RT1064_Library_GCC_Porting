#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$SCRIPT_DIR"

PYOCD_BIN="${PYOCD_BIN:-$REPO_DIR/.pyocd-venv/bin/pyocd}"
if [[ ! -x "$PYOCD_BIN" ]]; then
    echo "找不到 pyOCD：$PYOCD_BIN；请先按 README 安装项目虚拟环境。" >&2
    exit 1
fi
FIRMWARE="${FIRMWARE:-$SCRIPT_DIR/debug/tutorial.elf}"
if [[ ! -f "$FIRMWARE" ]]; then
    echo "找不到固件：$FIRMWARE；请先运行 ./build.sh。" >&2
    exit 1
fi

args=(--target "${PYOCD_TARGET:-mimxrt1064}" --frequency "${PYOCD_FREQUENCY:-1000000}" --no-wait)
if [[ -n "${PYOCD_UID:-}" ]]; then
    args+=(--uid "$PYOCD_UID")
fi

if ! "$PYOCD_BIN" flash "${args[@]}" --no-reset "$FIRMWARE"; then
    echo "烧录失败。请检查下载器、开发板供电、SWD 接线及 USB 权限（udev 规则）。" >&2
    exit 1
fi
"$PYOCD_BIN" reset "${args[@]}" --method sysresetreq
echo "烧录成功，芯片已复位运行。"
