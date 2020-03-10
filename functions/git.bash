#!/bin/bash

function _clean_git_lfs(){
    echo "Perform cleanup with lfs files!"
    git lfs uninstall
    git reset --hard
    git lfs install
    git lfs pull
    echo "Cleanup finished!"
}

function git_full_update() {
    git pull
    git submodule foreach --recursive "git checkout master"
    git submodule foreach --recursive "git pull"
    git submodule foreach --recursive "git checkout master"
}
