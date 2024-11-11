function _setup_git() {
    echo "Setup git aliases!"
    sudo apt update
    sudo apt install -y git
    git config --global alias.ch checkout
    git config --global alias.st status
    git config --global alias.ad add
    git config --global alias.cm commit
    git config --global alias.ps push
    git config --global alias.cam "commit --amend --no-edit"
    git config --global alias.hist "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short"
    git config --global alias.destroy "!git checkout . && git reset HEAD"
    git config --global alias.annihilate "!git checkout . && git reset HEAD --hard && git clean -fdx"
    git config --global alias.lg1 "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)'"
    git config --global alias.lg2 "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'"

    git config --global core.editor nvim
    echo
    echo "Setup global git ignore!"
    cp configs/gitignore_global ~/.gitignore_global
    git config --global core.excludesFile ~/.gitignore_global
    _command_finished
}
