#!/bin/bash
set -euo pipefail

########################
#  Imported scripts
########################
source setup_git.bash

########################
#  Global variables
########################
CALLER=${SUDO_USER:-$USER}
CALLER_HOME="/home/${CALLER}/"
BASH_CONFIGURATION_FOLDER="${CALLER_HOME}.bash/"
BASH_CONFIGURATION_FILE="${CALLER_HOME}.bashrc"
BASH_CONFIGURATION_FOLDER_FUNCTIONS="${BASH_CONFIGURATION_FOLDER}functions/"
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

function _install() {
    echo "Installing fonts-font-awesome..."
    apt update
    apt install -y fonts-font-awesome
    fc-cache -v
    _command_finished
}

function _source_scripts() {
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
    #chown ${CALLER}:${CALLER} ${BASH_CONFIGURATION_FILE}
    _command_finished
}

function _setup() {
    # _install
    echo "Create .bash folder in ${LOGNAME} home folder..."
    mkdir -p "${BASH_CONFIGURATION_FOLDER_FUNCTIONS}"
    _command_finished
    echo "Moving all functions to ${BASH_CONFIGURATION_FOLDER_FUNCTIONS}..."
    cp -R functions/* "${BASH_CONFIGURATION_FOLDER_FUNCTIONS}"
    #chown -R "${CALLER}:${CALLER}" ${BASH_CONFIGURATION_FOLDER}
    _command_finished
    _source_scripts
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
${END_SOURCE}
EOL
    else
        echo "Bash configuration file not found!"
        exit 1
    fi
    _command_finished
}

########################
#  Main Function
########################
if [[ "$#" -eq 0 ]];then
    # _check_for_sudo_privilages
    echo "Choose either basic, full, or aliases option!"
    exit 1
else
    case ${1} in
    --help)
        echo "Script is used to setup basic bash enviroment."
        echo "It changes the theme of shell and give a basic set"
        echo "of commands that you can use!"
        exit 1
        ;;
    basic)
        _greeting
        _setup
        ;;
    full)
        _greeting
        _setup
        _setup_aliases
        _setup_git
        ;;
    aliases)
        _setup_aliases
        _setup_git
        ;;
    *)
        echo "Unrecognized argument!"
        exit 1
        ;;
esac
fi
