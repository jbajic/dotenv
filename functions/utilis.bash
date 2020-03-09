#!/bin/bash

function i_unicode_copy_to_clipboard()
{
    local unicode=$1
    echo -ne "\u$unicode" | xclip -selection clipboard
}
