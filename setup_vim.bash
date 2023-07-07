function _setup_neovim() {
    echo "Setting up neovim!"
    sudo apt update
    sudo apt install curl -y
    mkdir -p ~/.local/bin
    pushd ~/.local/bin/
      curl -LO  https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
      chmod u+x nvim.appimage
      mv nvim.appimage nvim
    popd
    cp -r nvim_new ~/.config/nvim/

    pushd ~
      git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
      cd nerd-fonts
      ./install
    popd

    _command_finished
}

