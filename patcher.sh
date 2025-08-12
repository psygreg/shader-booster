#!/bin/bash
# functions

# dependency checker
depcheck () {

    local dependencies=()
    if [[ "$ID_LIKE" =~ (suse|rhel|fedora) ]] || [[ "$ID" =~ (fedora|suse) ]]; then
        dependencies=(wget newt)
    elif [ "$ID" == "arch" ] || [[ "$ID_LIKE" =~ (arch) ]]; then
        dependencies=(wget libnewt)
    elif [[ "$ID_LIKE" =~ (ubuntu|debian) ]] || [ "$ID" == "debian" ]; then
        dependencies=(wget whiptail)
    fi
    for dep in "${dependencies[@]}"; do
        if [[ "$ID_LIKE" =~ (suse|rhel|fedora) ]] || [[ "$ID" =~ (fedora|suse) ]]; then
            if rpm -qi "$dep" 2>/dev/null 1>&2; then
                continue
            else
                if [ "$ID_LIKE" == "suse" ]; then
                    sudo zypper in "$dep" -y
                else
                    sudo dnf in "$dep" -y
                fi
            fi
        elif [ "$ID" == "arch" ] || [[ "$ID_LIKE" =~ (arch) ]]; then
            if pacman -Qi "$dep" 2>/dev/null 1>&2; then
                continue
            else
                sudo pacman -S --noconfirm "$dep"
            fi
        elif [[ "$ID_LIKE" =~ (ubuntu|debian) ]] || [ "$ID" == "debian" ]; then
            if dpkg -s "$dep" 2>/dev/null 1>&2; then
                continue
            else
                sudo apt install -y "$dep"
            fi
        fi
    done

}

# patch for Nvidia GPUs
patch_nv () {

    cd $HOME
    wget -O patch-nvidia https://raw.githubusercontent.com/psygreg/shader-booster/refs/heads/main/patch-nvidia;
    echo -e "\n$(cat ${HOME}/patch-nvidia)" >> "${DEST_FILE}"
    rm ${HOME}/patch-nvidia
}

# patch for Mesa-driven GPUs
patch_mesa () {

    cd $HOME
    wget -O patch-mesa https://raw.githubusercontent.com/psygreg/shader-booster/refs/heads/main/patch-mesa;
    echo -e "\n$(cat ${HOME}/patch-mesa)" >> "${DEST_FILE}"
    rm ${HOME}/patch-mesa
}

# --- Início do Runtime ---
. /etc/os-release
depcheck

# LÓGICA DE DETECÇÃO ALTERADA para suportar múltiplos GPUs.
HAS_NVIDIA=$(lspci | grep -i 'nvidia')
HAS_MESA=$(lspci | grep -Ei '(vga|3d)' | grep -vi nvidia)
PATCH_APPLIED=0

# A estrutura geral do runtime é mantida, começando pela verificação do .booster
if [ ! -f ${HOME}/.booster ]; then
    # O bloco para encontrar o DEST_FILE é IDÊNTICO AO ORIGINAL
    if [[ -f "${HOME}/.bash_profile" ]]; then
        DEST_FILE="${HOME}/.bash_profile"
    elif [[ -f "${HOME}/.profile" ]]; then
        DEST_FILE="${HOME}/.profile"
    elif [[ -f "${HOME}/.zshrc" ]]; then
        DEST_FILE="${HOME}/.zshrc"
    else
        # Mensagem de erro idêntica à original
        whiptail --title "Shader Booster" --msgbox "No valid shell found." 8 78
        exit 1
    fi
    
    # LÓGICA DE EXECUÇÃO ALTERADA para chamar os patches de forma independente
    if [[ -n "$HAS_NVIDIA" ]]; then
        patch_nv
        PATCH_APPLIED=1
    fi
    
    if [[ -n "$HAS_MESA" ]]; then
        patch_mesa
        PATCH_APPLIED=1
    fi

    # Se ao menos um patch foi aplicado, executa os passos finais IDÊNTICOS AOS DA FUNÇÃO ORIGINAL
    if [ $PATCH_APPLIED -eq 1 ]; then
        whiptail --title "Shader Booster" --msgbox "Success! Reboot to apply." 8 78
        # Método de criação do .booster idêntico ao original
        echo "1" > "${HOME}/.booster"
        exit 0
    else
        # Adicionado um feedback caso nenhuma placa seja encontrada
        whiptail --title "Shader Booster" --msgbox "No compatible GPU found to patch." 8 78
        exit 1
    fi
else
    # Bloco else idêntico ao original
    whiptail --title "Shader Booster" --msgbox "System already patched." 8 78
    exit 0
fi
