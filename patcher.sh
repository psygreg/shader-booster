#!/bin/bash
# vars

SUCCESS="Success! Reboot to apply."
APPLIED="Patch already present in '$DEST_FILE'. Nothing to do."

# functions

patch_nv () {
    PATCH_CONTENT=$(<"patch-nvidia")
    if grep -Fxq "$PATCH_CONTENT" "$DEST_FILE"; then
        echo "$APPLIED"
        sleep 5
        exit 0
    else
        cat "patch-nvidia" >> "$DEST_FILE"
        echo "$SUCCESS"
        sleep 5
        exit 0
    fi
}
patch_mesa () {
    PATCH_CONTENT=$(<"patch-mesa")
    if grep -Fxq "$PATCH_CONTENT" "$DEST_FILE"; then
        echo "$APPLIED"
        sleep 5
        exit 0
    else
        cat "patch-mesa" >> "$DEST_FILE"
        echo "$SUCCESS"
        sleep 5
        exit 0
    fi
}

# runtime

GPU=$(lspci | grep -i '.* vga .* nvidia .*')
shopt -s nocasematch
if [ "$SHELL" = "$(which fish)" ] || [ "$FISH_VERSION" ]; then
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
elif [[ -f "$HOME/.bash_profile" ]]; then
    DEST_FILE="$HOME/.bash_profile"
    if [[ $GPU == *' nvidia '* ]]; then
        patch_nv
    else
        patch_mesa
    fi
elif [[ -f "$HOME/.profile" ]]; then
    DEST_FILE="$HOME/.profile"
    if [[ $GPU == *' nvidia '* ]]; then
        patch_nv
    else
        patch_mesa
    fi
elif [[ -f "$HOME/.zshrc" ]]; then
    DEST_FILE="$HOME/.zshrc"
    if [[ $GPU == *' nvidia '* ]]; then
        patch_nv
    else
        patch_mesa
    fi
else
    echo "No valid shell found, aborting..."
    sleep 5
    exit 1
fi
