function _setup_neovim() {
    echo "Setting up neovim!"
    sudo apt update
    sudo apt install -y neovim
    cp -r nvim_new ~/.config/nvim/
    _command_finished
}

