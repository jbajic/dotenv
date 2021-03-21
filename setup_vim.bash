
function _setup_vim() {
    echo "Setting up vim!"
    mkdir -p ~/.vim/undodir
    cp vim/vimrc ~/.vimrc
    vim +'PlugInstall --sync' +qa
}

