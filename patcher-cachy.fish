#!/bin/fish
# vars
SUCCESS="Success! Reboot to apply."
APPLIED="Patch already present in '$DEST_FILE'. Nothing to do."

# runtime
GPU=$(lspci | grep -i '.* vga .* nvidia .*')
shopt -s nocasematch
if command -v fish &>/dev/null; then
    if [[ $GPU == *' nvidia '* ]]; then
        set -x --universal __GL_SHADER_DISK_CACHE_SIZE '12000000000'
        echo "$SUCCESS"
        sleep 5
        exit 0
    else
        set -x --universal AMD_VULKAN_ICD 'RADV'
        set -x --universal MESA_SHADER_CACHE_MAX_SIZE '12G'
        echo "$SUCCESS"
        sleep 5
        exit 0
    fi
else
    echo "If you're not running this on CachyOS, use the standard 'patcher.sh' for bash and zsh."
    sleep 5
    exit 1
fi