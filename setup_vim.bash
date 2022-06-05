function _setup_vim() {
    echo "Setting up vim!"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    mkdir -p ~/.vim/undodir
    cp vim/vimrc ~/.vimrc
    vim +'PlugInstall --sync' +qa
}
