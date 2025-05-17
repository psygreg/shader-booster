#!/bin/bash

# functions

patch_nv () {
    PATCH_CONTENT=$(<"patch-nvidia")
    if grep -Fxq "$PATCH_CONTENT" "$DEST_FILE"; then
        whiptail --title "Shader Booster" --msgbox "System already patched. Nothing to do" 8 78
        cd ..
        rm -rf spatcher
        exit 0
    else
        cat "patch-nvidia" >> "$DEST_FILE"
        whiptail --title "Shader Booster" --msgbox "Success! Reboot to apply." 8 78
        cd ..
        rm -rf spatcher
        exit 0
    fi
}
patch_mesa () {
    PATCH_CONTENT=$(<"patch-mesa")
    if grep -Fxq "$PATCH_CONTENT" "$DEST_FILE"; then
        whiptail --title "Shader Booster" --msgbox "System already patched. Nothing to do" 8 78
        cd ..
        rm -rf spatcher
        exit 0
    else
        cat "patch-mesa" >> "$DEST_FILE"
        whiptail --title "Shader Booster" --msgbox "Success! Reboot to apply." 8 78
        cd ..
        rm -rf spatcher
        exit 0
    fi
}

# runtime

sudo apt install wget whiptail
GPU=$(lspci | grep -i '.* vga .* nvidia .*')
shopt -s nocasematch
if [[ -f "$HOME/.bash_profile" ]]; then
    DEST_FILE="$HOME/.bash_profile"
    if [[ $GPU == *' nvidia '* ]]; then
        cd $HOME
        mkdir spatcher
        cd spatcher
        wget -O patch-nvidia https://raw.githubusercontent.com/psygreg/shader-booster/refs/heads/main/patch-nvidia;
        patch_nv
    else
        cd $HOME
        mkdir spatcher
        cd spatcher
        wget -O patch-mesa https://raw.githubusercontent.com/psygreg/shader-booster/refs/heads/main/patch-mesa;
        patch_mesa
    fi
elif [[ -f "$HOME/.profile" ]]; then
    DEST_FILE="$HOME/.profile"
    if [[ $GPU == *' nvidia '* ]]; then
        cd $HOME
        mkdir spatcher
        cd spatcher
        wget -O patch-nvidia https://raw.githubusercontent.com/psygreg/shader-booster/refs/heads/main/patch-nvidia;
        patch_nv
    else
        cd $HOME
        mkdir spatcher
        cd spatcher
        wget -O patch-mesa https://raw.githubusercontent.com/psygreg/shader-booster/refs/heads/main/patch-mesa;
        patch_mesa
    fi
elif [[ -f "$HOME/.zshrc" ]]; then
    DEST_FILE="$HOME/.zshrc"
    if [[ $GPU == *' nvidia '* ]]; then
        cd $HOME
        mkdir spatcher
        cd spatcher
        wget -O patch-nvidia https://raw.githubusercontent.com/psygreg/shader-booster/refs/heads/main/patch-nvidia;
        patch_nv
    else
        cd $HOME
        mkdir spatcher
        cd spatcher
        wget -O patch-mesa https://raw.githubusercontent.com/psygreg/shader-booster/refs/heads/main/patch-mesa;
        patch_mesa
    fi
else
    whiptail --title "Shader Booster" --msgbox "No valid shell found." 8 78
    exit 1
fi
