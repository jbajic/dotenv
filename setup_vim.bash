function _setup_neovim() {
    echo "Setting up neovim!"
    sudo apt update
    sudo apt install curl unzip ripgrep fontconfig -y

    # Intall neovim from release pages
    echo "Installing neovim from release pages!"
    pushd ~/.local/bin/
      curl -LO  https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
      chmod u+x nvim.appimage
      mv nvim.appimage nvim
    popd
    cp -r nvim ~/.config/nvim/

    # Install fonts
    echo "Installing fonts!"
    sudo mkdir -p /usr/local/share/fonts
    local FONTS=("FiraCode" "Hack" "SourceCodePro" "SpaceMono")
    pushd /usr/local/share/fonts
      for FONT in "${FONTS[@]}"; do
        sudo curl -LO "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT}.zip"
        sudo unzip -o "${FONT}.zip"
        sudo rm "${FONT}.zip"
      done
      sudo fc-cache -fv
    popd

    _command_finished
}

