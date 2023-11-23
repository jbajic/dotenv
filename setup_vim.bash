function _setup_neovim() {
    echo "Setting up neovim!"
    sudo apt update
    # Fuse is for appimage
    sudo apt install curl unzip ripgrep fontconfig fuse -y

    # Intall neovim from release pages
    echo "Installing neovim from release pages!"
    pushd ~/.local/bin/
      curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
      chmod u+x nvim.appimage
      mv nvim.appimage nvim
    popd
    rm -rf ~/.config/nvim/
    cp -r nvim ~/.config/

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

    # Install patched fonts to enable icons
    curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.0/Hack.tar.xz > hack.tar.xz
    tar -xvf hack.tar.gs -C hack
    pushd hack
      cp ./* /usr/share/fonts/Hack/
    popd

    _command_finished
}

