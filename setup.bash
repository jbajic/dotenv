#!/bin/bash
set -euo pipefail

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
BASH_CONFIGURATION_FOLDER="${CALLER_HOME}/.bash"
BASH_CONFIGURATION_FILE="${CALLER_HOME}/.bashrc"
BASH_CONFIGURATION_FOLDER_FUNCTIONS="${BASH_CONFIGURATION_FOLDER}/functions/"
ps1_font_type="unicode"

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
    echo "Create .bash folder in ${LOGNAME} home folder..."
    mkdir -p "${BASH_CONFIGURATION_FOLDER_FUNCTIONS}"
    echo "Moving all functions to ${BASH_CONFIGURATION_FOLDER_FUNCTIONS}..."
    cp -R functions/* "${BASH_CONFIGURATION_FOLDER_FUNCTIONS}"

    echo "Source all script from .bash folder into default"
    echo "bash configuration file."
    local BEGIN_SOURCE="#### CUSTOM FUNCTIONS START"
    local END_SOURCE="#### CUSTOM FUNCTIONS END"
    # Remove any previous sourcing
    sed -i "/${BEGIN_SOURCE}/,/${END_SOURCE}/d" ${BASH_CONFIGURATION_FILE}

    if [[ -f "${BASH_CONFIGURATION_FILE}" ]]; then
cat >> "${BASH_CONFIGURATION_FILE}" <<EOL
${BEGIN_SOURCE}
ps1_font_type="unicode"
for file in ${BASH_CONFIGURATION_FOLDER_FUNCTIONS}*; do
    source \${file}
done
PS1=\$simple_bash
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
    sed -i "/${BEGIN_SOURCE}/,/${END_SOURCE}/d" ${BASH_CONFIGURATION_FILE}

    if [[ -f "${BASH_CONFIGURATION_FILE}" ]]; then
cat >> "${BASH_CONFIGURATION_FILE}" <<EOL
${BEGIN_SOURCE}
alias da='du -Sh | sort -h'
alias source=source_venv
alias ap=ansible-playbook
${END_SOURCE}
EOL
    else
        echo "Bash configuration file not found!"
        exit 1
    fi
}


function _setup_i3() {
    echo "Setting up i3 config"
    mkdir -p ${CALLER_HOME}/.config/i3/scripts
    cp configs/i3 ${CALLER_HOME}/.config/i3/config
    cp configs/i3exit ${CALLER_HOME}/.config/i3/scripts/i3exit
    _command_finished
}

function _setup_polybar() {
    echo "Setting up polybar config"
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

function _init() {
    echo "Installing all the neccesary stuff!"
    sudo apt update
    sudo apt install -y fonts-font-awesome i3 i3lock \
    cmake cmake-data libcairo2-dev libxcb1-dev libxcb-ewmh-dev \
    libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev \
    libxcb-xkb-dev pkg-config python3-xcbgen xcb-proto libxcb-xrm-dev i3-wm \
    libasound2-dev libmpdclient-dev libiw-dev libcurl4-openssl-dev libpulse-dev \
    libxcb-composite0-dev libjsoncpp-dev python3-sphinx imagemagick gcc g++ \
    libuv1 libuv1-dev

    # Install polybar
    echo "Install polybar"
    pushd ~
        rm -rf polybar
        git clone https://github.com/jaagr/polybar.git
        cd polybar && ./build.sh --all-features --auto
        rm -rf polybar
    popd
    fc-cache -v
    _command_finished
}

function _help() {
    echo "Script is used to setup basic bash enviroment."
    echo "It changes the theme of shell and give a basic set"
    echo "of commands that you can use!"
    echo "  init => Install all neccesarry packages."
    echo "  basic => Git & bash aliases"
    echo "  full => Git, bash aliases, vim, i3 & polybar"
    exit 1
}

########################
#  Main Function
########################
if [[ "${#}" -eq 0 ]];then
    echo "Needs an argument"
    _help
else
    case ${1} in
    --help)
        _help
        ;;
    init)
        _init
        ;;
    basic)
        _greeting
	    _setup_git
	    _setup_bash
        ;;
    full)
        _greeting
        _setup_git
	    _setup_vim
	    _setup_i3
	    _setup_polybar
	    _setup_xrandr
        ;;
    *)
        echo "Unrecognized argument!"
        _help
        ;;
esac
fi
