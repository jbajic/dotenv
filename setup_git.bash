function _setup_git() {
    echo "Setup git aliases!"
    git config --global alias.ch checkout
    git config --global alias.st status
    git config --global alias.ad add
    git config --global alias.hist "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short"
    git config --global alias.destroy "!git checkout . && git reset HEAD"
    git config --global alias.annihilate "!git checkout . && git reset HEAD --hard && git clean -fdx"
    _command_finished
}
