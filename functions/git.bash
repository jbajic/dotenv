#!/bin/bash

function _clean_git_lfs(){
    echo "Perform cleanup with lfs files!"
    git lfs uninstall
    git reset --hard
    git lfs install
    git lfs pull
    echo "Cleanup finished!"
}

# function _git(){
#     if [[ $@ == "destroy" ]]; then
#         _git_destroy
#     elif [[ $@ == "annihilate" ]]; then
#         _git_annihilate
#     else
#         command git "$@"
#     fi
# }

function _git_destroy() {
    command git checkout .
    command git reset --hard HEAD
}

function _git_annihilate() {
    command git checkout .
    command git reset --hard HEAD
    command git clean -fdx
}

