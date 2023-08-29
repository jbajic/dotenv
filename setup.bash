#!/bin/bash
set -euo pipefail

function _help() {
    echo "Script is used to setup basic bash enviroment."
    echo "It changes the theme of shell and give a basic set"
    echo "of commands that you can use!"
    echo "First argument must be type of shell to use zsh or bash"
    echo "  basic => Git & bash aliases"
    echo "  full => Git, bash aliases, neovim, i3 env"
    exit 1
}

########################
# Input arguments
########################
if [[ "${#}" -eq 3 ]];then
    echo "Needs two arguments"
    _help
fi

SHELL=${1:-""}
SETUP=${2:-""}

case ${SHELL} in
  bash)
    echo "Setting configuration for 'bash'"
    ;;
  zsh)
    echo "Setting configuration for 'zsh'"
    ;;
  *)
    _help
    exit 1
  ;;
esac
########################
#  Imported scripts
########################
source setup_git.bash
source setup_vim.bash

########################
#  Global variables
########################
CALLER=${SUDO_USER:-$USER}
CALLER_HOME="/home/${CALLER}"
SHELL_CONFIGURATION_FOLDER="${CALLER_HOME}/.${SHELL}"
SHELL_CONFIGURATION_FILE="${CALLER_HOME}/.${SHELL}rc"
SHELL_CONFIGURATION_FOLDER_FUNCTIONS="${SHELL_CONFIGURATION_FOLDER}/functions/"

source functions/colors.bash
########################
#  Functions
########################
function _greeting() {
    echo "Setup bash enviroment:"
}

function _command_finished() {
    printf "${color_fg_green}Done!${color_fg_reset}\n"
}

function _check_for_sudo_privilages() {
    if [[ "${EUID}" -ne 0 ]]; then
        echo "Please run script with sudo privilages!"
        exit 1
    fi
}

function _setup_bash() {
    echo "Create a .local/bin directory"
    mkdir -p "${CALLER_HOME}/.local/bin"

    sudo apt update && sudo apt upgrade -y
    sudo apt install -y fzf fd-find bat
    ln -s $(which fdfind) ~/.local/bin/fd

    echo "Create .shell directory in ${LOGNAME} home folder..."
    mkdir -p "${SHELL_CONFIGURATION_FOLDER_FUNCTIONS}"
    echo "Moving all functions to ${SHELL_CONFIGURATION_FOLDER_FUNCTIONS}..."
    cp -R functions/* "${SHELL_CONFIGURATION_FOLDER_FUNCTIONS}"

    echo "Source all script from .bash folder into default"
    echo "bash configuration file."
    local BEGIN_SOURCE="#### CUSTOM FUNCTIONS START"
    local END_SOURCE="#### CUSTOM FUNCTIONS END"
    # Remove any previous sourcing
    sed -i "/${BEGIN_SOURCE}/,/${END_SOURCE}/d" ${SHELL_CONFIGURATION_FILE}

    # Copy fzf key bindings
    cp /usr/share/doc/fzf/examples/key-bindings.bash ~/.bash/key-bindings-fzf.bash
    sudo chmod 777 ~/.bash/key-bindings-fzf.bash

    # Update shell configuration file
    if [[ -f "${SHELL_CONFIGURATION_FILE}" ]]; then
cat >> "${SHELL_CONFIGURATION_FILE}" <<EOL
${BEGIN_SOURCE}

# Source all bash scripts
for file in ${SHELL_CONFIGURATION_FOLDER_FUNCTIONS}*; do
    source \${file}
done

# Use fzf
source ~/.bash/key-bindings-fzf.bash
export FZF_DEFAULT_COMMAND="fd --hidden"
export FZF_CTRL_T_COMMAND="\$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="\$FZF_DEFAULT_COMMAND --type d"

${END_SOURCE}
EOL
    else
        echo "Bash configuration file not found!"
        exit 1
    fi
    _setup_aliases
    _command_finished
}

function _setup_aliases() {
    echo "Source system aliases!"
    local BEGIN_SOURCE="#### Useful aliases START"
    local END_SOURCE="#### Useful aliases END"
    # Remove any previous sourcing
    sed -i "/${BEGIN_SOURCE}/,/${END_SOURCE}/d" ${SHELL_CONFIGURATION_FILE}

    if [[ -f "${SHELL_CONFIGURATION_FILE}" ]]; then
cat >> "${SHELL_CONFIGURATION_FILE}" <<EOL
${BEGIN_SOURCE}

alias da='du -Sh | sort -h'
alias source=source_venv
alias ap=ansible-playbook
alias cat=bat

${END_SOURCE}
EOL
    else
        echo "Bash configuration file not found!"
        exit 1
    fi
}

function _setup_env() {
    _setup_i3
    _setup_polybar
    _setup_xrandr
    _setup_dunst
    _setup_alacritty
    _setup_tmux
}

function _setup_i3() {
    echo "Setting up i3 config"
    sudo apt update
    sudo apt install -y i3 i3lock i3-wm
    mkdir -p ${CALLER_HOME}/.config/i3/scripts
    cp configs/i3 ${CALLER_HOME}/.config/i3/config
    cp configs/i3exit ${CALLER_HOME}/.config/i3/scripts/i3exit
    _command_finished
}

function _setup_polybar() {
    echo "Setting up polybar config"
    sudo apt update
    sudo apt install polybar imagemagick -y
    mkdir -p ${CALLER_HOME}/.config/polybar
    cp configs/polybar ${CALLER_HOME}/.config/polybar/config.ini
    cp configs/polybar_launch.sh ${CALLER_HOME}/.config/polybar/launch.sh
    _command_finished
}

function _setup_xrandr() {
    echo "Setting up xrand configuration in .xprofile file"
    cp configs/xprofile ${CALLER_HOME}/.xprofile
    _command_finished
}

function _setup_dunst() {
    echo "Setting up dunst configuration in .config/dunst file"
    mkdir -p ${CALLER_HOME}/.config/dunst
    cp configs/dunstrc ${CALLER_HOME}/.config/dunst/dunstrc
    cp images/alert.png ${CALLER_HOME}/.config/dunst/alert.png
    cp images/notification.png ${CALLER_HOME}/.config/dunst.notification.png
    _command_finished
}

function _setup_alacritty() {
    echo "Setting up alacritty!"
    sudo apt update && sudo apt upgrade -y
    sudo add-apt-repository ppa:aslatter/ppa -y
    sudo apt update
    sudo apt install alacritty
    sudo update-alternatives --config x-terminal-emulator
    mkdir -p ${CALLER_HOME}/.config/alacritty
    cp configs/alacritty.yml ${CALLER_HOME}/.config/alacritty.yml
    _command_finished
}

function _setup_tmux() {
  echo "Setting up tmux!"
  sudo apt update && sudo apt upgrade -y
  sudo apt install -y tmux
  mkdir -p ${CALLER_HOME}/.config/tmux
  cp configs/tmux.conf ${CALLER_HOME}/config/tmux/tmux.conf
  _command_finished
}


########################
#  Main Function
########################
case ${SETUP} in
  --help)
    _help
    ;;
  basic)
    _greeting
    _setup_git
    _setup_bash
    ;;
  full)
    _greeting
    #_setup_git
    #_setup_neovim
    _setup_bash
    #_setup_env
    ;;
  *)
    echo "Unrecognized argument!"
    _help
    ;;
esac

