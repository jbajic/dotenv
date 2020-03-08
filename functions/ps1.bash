#!/bin/bash

# For unicode font type, export ps1_font_type="unicode"
if [ "$ps1_font_type" = "unicode" ]; then
    export ps1_char_branch=" "
    export ps1_char_clock=" "
    export ps1_char_error=" "
    export ps1_char_folder=" "
    export ps1_char_monitor=" "
    export ps1_char_prompt="$ "
    export ps1_char_refresh=" "
else
    export ps1_char_branch=""
    export ps1_char_clock=""
    export ps1_char_error="!"
    export ps1_char_folder=""
    export ps1_char_monitor=""
    export ps1_char_prompt="$ "
    export ps1_char_refresh="(r)"
fi

function ps1_print_error()
{
    if [[ $? -ne 0 ]]; then
        printf "$ps1_char_error "
    fi
}

function ps1_print_git_branch()
{
    local git_branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    local git_status="$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1)"
    if [[ -n "${git_branch}" ]]; then
        local text_color=""
        local git_icon=""
        if [[ "${git_status}" =~ "working directory clean" ]]; then
            text_color=${color_fg_red}
            git_icon=${ps1_char_branch}
        elif [[ ${git_status} =~ "Your branch is ahead of" ]]; then
            text_color=${COLOR_YELLOW}
            git_icon=${ps1_char_branch}
        elif [[ ${git_status} =~ "nothing to commit" ]]; then
            text_color=${COLOR_GREEN}
            git_icon=${ps1_char_branch}
        else
            text_color=${COLOR_OCHRE}
            git_icon=${ps1_char_branch}
        fi
        printf "\[${color_fg_red}\]${git_icon}${git_branch}"
    fi
}

function ps1_color_fg_git()
{
    local text_color=""
}

function ps1_clock()
{
    local now=$(date +"%T")
    printf $now
}


# Set format of \w, example: ".../_directory_/_directory_/_directory_"
export PROMPT_DIRTRIM=3

export ps1_style_1=\
$color_fg_red'$(ps1_print_error)'\
$i_color_fg_grey$ps1_char_clock'$(ps1_clock) '\
$i_color_fg_green$ps1_char_monitor'\u@\h '\
$i_color_fg_light_blue$ps1_char_folder'\w '\
$i_color_fg_reset\
$ps1_char_prompt

export ps1_style_2=\
$color_fg_red'$(ps1_print_error)'\
$color_fg_green$ps1_char_monitor'\u@\h '\
$color_fg_light_blue$ps1_char_folder'\w '\
$color_fg_grey\
'$(ps1_print_git_branch)'\
$color_fg_reset\
$ps1_char_prompt

export ps1_style_3=\
$color_fg_red'$(ps1_print_error)'\
$color_fg_grey$ps1_char_clock'$(ps1_clock) '\
$color_fg_green$ps1_char_monitor'\u@\h '\
$color_fg_light_blue$ps1_char_folder'\w '\
$color_fg_grey\
'$(ps1_print_git_branch)'\
$color_fg_reset\
$ps1_char_prompt

export simple_bash=\
"\[$color_fg_red\]$(eval ps1_print_error)"\
"\[$color_fg_green\]$ps1_char_monitor\u "\
"\[$color_fg_light_blue\]$ps1_char_folder \w "\
"\[$color_fg_grey\]"\
"$(eval ps1_print_git_branch)"\
"\[$color_fg_reset\]"\
"$ps1_char_prompt"

function ps1_styles_set()
{
    # arg[1] -> default style
    # arg[2] -> style specific for some programs

    if [[ $TERM_PROGRAM == "vscode" ]] || [[ $GIO_LAUNCHED_DESKTOP_FILE == *"clion"* ]]; then
        export PS1=$2
    else
        export PS1=$1
    fi
}
