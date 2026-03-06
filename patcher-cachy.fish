#!/bin/fish

# runtime
set GPU (lspci | grep -i 'vga' | grep -i 'nvidia')

if string match -q '*nvidia*' "$GPU"
    set -x --universal __GL_SHADER_DISK_CACHE_SIZE '10000000000'
else
    set -x --universal AMD_VULKAN_ICD 'RADV'
    set -x --universal MESA_SHADER_CACHE_MAX_SIZE '10G'
end

exit 0