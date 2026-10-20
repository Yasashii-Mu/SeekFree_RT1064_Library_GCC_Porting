# Ubuntu 开发环境使用说明

本机工程为逐飞 RT1064 裸机 GCC 库，烧录与调试使用 CMSIS-DAP + pyOCD。

## 在 VSCode 中开发

打开仓库根目录的 `RT1064.code-workspace`，或直接打开 `Project` 文件夹。
默认示例在 `Project/USER/src/main.c`，运行后核心板 LED 闪烁。
库源码在仓库的 `Libraries` 文件夹，可通过跳转到定义打开。

- `Ctrl+Shift+B`：增量编译，首次会自动配置 CMake。
- 命令面板 → `Tasks: Run Task` → `buildfull`：清理后完整编译。
- 命令面板 → `Tasks: Run Task` → `flash`：编译成功后烧录并复位运行。
- `flash (不重新编译)`：只烧录现有固件。
- `F5`：启动 pyOCD，烧录并停在 `main`，可以设置断点。
- `检查下载器`：列出当前可用调试器。

程序由 Flash 启动后复制到 SDRAM 运行。烧录和调试使用系统复位来执行启动初始化，
调试使用硬件断点，避免启动复制代码时覆盖软件断点。

不连接下载器也可以编译；烧录和 F5 调试需要下载器、开发板供电及 SWD 接线。

## 命令行编译与烧录

在仓库根目录运行：

```bash
./Project/GCC/buildfull.sh
./Project/GCC/build.sh
./Project/GCC/flash.sh
```

构建目录：`Project/GCC/build`；固件：`Project/GCC/debug/tutorial.elf`。
编译脚本会传播真实的失败退出码，VSCode 的 `flash` 任务依赖编译成功。
可执行 `./Project/GCC/clean.sh` 清理生成文件。

CMake Tools 使用 `Project/GCC/CMakePresets.json` 中的 `ubuntu-arm-debug` 预设。
如果提示选择 Configure Preset 或 Build Preset，选择 `ubuntu-arm-debug`。

## 下载器和 USB 权限

项目的 pyOCD 在 `.pyocd-venv` 中，已确认支持内置目标 `mimxrt1064`。
本机已安装 `/etc/udev/rules.d/99-seekfree-dap.rules`，允许当前桌面用户及
`plugdev` 用户组访问逐飞 CMSIS-DAP（USB ID `c251:f00a`）及对应 hidraw 接口。
插入后检查：

```bash
.pyocd-venv/bin/pyocd list
```

如果有多个下载器，或希望降低 SWD 频率：

```bash
PYOCD_UID=你的下载器序列号 ./Project/GCC/flash.sh
PYOCD_FREQUENCY=500k ./Project/GCC/flash.sh
```

## GitHub 更新与上传

个人 Fork：<https://github.com/Yasashii-Mu/SeekFree_RT1064_Library_GCC_Porting>

- `origin`：个人 Fork，日常拉取和推送使用此远程。
- `upstream`：`hilookas/SeekFree_RT1064_Library_GCC_Porting`，获取原作者更新。
- `main` 跟踪 `origin/main`。
- 本仓库 Git 身份使用 GitHub 用户名和 noreply 邮箱，不影响其他工程。
- 本机 Git 使用 GitHub CLI 的授权作为凭据；GitHub 网页登录和本机 Git 授权是分开的。

VSCode 左侧“源代码管理”：检查修改 → 暂存所需文件 → 输入提交说明 → 提交 → 推送。
从个人仓库更新可以在“源代码管理”的菜单中选择“拉取”。
命令行等价操作（在仓库根目录执行）：

```bash
git pull --ff-only
git status
git add Project/USER
git commit -m "描述本次修改"
git push
```

从原作者仓库同步更新时，先保存并提交自己的改动，再执行：

```bash
git fetch upstream
git merge upstream/main
git push
```

如果存在冲突，在 VSCode 中解决冲突后再提交。虚拟环境、缓存、固件、日志均已忽略，
不会随普通 `git add` 提交；请只提交自己检查过的源码和配置。

## 当前验证范围

已验证 Ubuntu 完整编译、增量编译、ARM ELF 及调试符号、pyOCD 目标识别、
下载器未连接时的错误退出、GitHub 个人仓库拉取与推送。
实板烧录、复位和断点调试需要连接硬件后验证。
