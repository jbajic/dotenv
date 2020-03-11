#/bin/bash

function _clang_all_formater() {
    find . -type f -regex ".*\.[cpp,hpp]+" -print | paste -sd " " | xargs clang-format-6.0 -i -verbose -style=file
}

function _clang_diff_formater() {
    git --no-pager diff master...HEAD --name-only | paste -sd " " | xargs clang-format-6.0 -i -verbose -style=file
}

function _clang_create_file_all_formatter() {
    if [[ ${#} -lt 1 ]] || [[ ${#} -gt 2 ]]; then
        echo "Illegal number of parameters"
        return 1
    fi
    local folder=${1}
    local result_file=${PWD}"/clang_check.txt"
    if [[ ! -z ${2} ]]; then
        result_file=${2}
    fi
    pushd $folder
    local all_src_and_hdr_files=$(find . -type f -regex ".*\.[cpp,hpp]+" -print | paste -sd " ")
    for file in ${all_src_and_hdr_files}; do
        clang-format-6.0 -i -style=file -verbose ${file}
    done
    git diff > ${result_file}
    if [[ -s "${result_file}" ]]; then
        echo "Clang check failed!"
    else
        echo "Clang check ok!"
    fi
    popd
}

function _black_formatter()
{
    black --line-length=120 $@
}
