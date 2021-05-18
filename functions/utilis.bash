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
