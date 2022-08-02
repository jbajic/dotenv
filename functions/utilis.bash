#!/bin/bash

function i_unicode_copy_to_clipboard()
{
    local unicode=$1
    echo -ne "\u$unicode" | xclip -selection clipboard
}

function source_venv()
{
    if [[ ! -z ${@} ]]; then
        source ${@}
    elif [[ -d ".venv" ]]; then
        source .venv/bin/activate
    else
        source ${@}
    fi
}

function cm-build() {
    local mode=${1:-Debug}
    mkdir -p build
    pushd build
        cmake -DCMAKE_BUILD_TYPE=${mode} ..
        make
    popd
}

stacktrace () {
    # Tyler's cool tip
    # sudo gdb may be needed here, depending on your system settings around ptrace
    gdb --batch -ex "t a a bt" -p `pgrep $1`
}
