#/bin/bash

function _clang_diff_formater() {
    git --no-pager diff master...HEAD --name-only | paste -sd " " | xargs clang-format-6.0 -i -verbose -style=file
}

function _black_formatter()
{
    black --line-length=120 $@
}
