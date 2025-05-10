# shader-patcherx
### Simple bash script to increase the shader cache size globally on your Linux system.

Effective on decreasing loading times and stutters, specially in recently released games. 

Compatible only with systems running **bash**, **zsh** or **fish** as their default shell, and running either the Nvidia drivers **version 535 or later** or **Mesa 23.1 or later**.

## Systems known to be compatible on their default settings and latest versions

- Ubuntu (base and official flavours)
- Linux Mint
- CachyOS (use `patcher-cachy.fish` instead of `patcher.sh`)
- Fedora (official and spins, except atomic)
- openSUSE (Tumbleweed)
- MX Linux (AHS only)
- Arch Linux
- Zorin OS
- Manjaro
- Big Linux
- Debian

## Usage

### Without terminal
- Download the proper script for your system on [Releases](https://github.com/psygreg/shader-patcherx/releases).
- Right-click the file, go to Properties on the submenu then set it to run as a program.
- Double click it to run.

### On terminal
`git clone https://github.com/psygreg/shader-patcherx.git`\
`cd shader-patcherx`\
`chmod +x patcher.sh` for most systems; or `chmod +x patcher-cachy.fish` for *CachyOS* \
`./patcher.sh` for most systems; or `./patcher-cachy.fish` for *CachyOS*

**You can delete the "shader-patcherx" folder once finished.**
