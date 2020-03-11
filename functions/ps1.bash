#!/bin/bash

# For unicode font type, export ps1_font_type="unicode"
if [ "$ps1_font_type" = "unicode" ]; then
    export ps1_char_branch=" "
    export ps1_char_clock=" "
    export ps1_char_error=""
    export ps1_char_folder=" "
    export ps1_char_monitor=" "
    export ps1_char_prompt="$ "
    export ps1_char_refresh=" "
    export ps1_char_edit=" "
    export ps1_char_user=" "
    export ps1_char_cloud="  "
else
    export ps1_char_branch=""
    export ps1_char_clock=""
    export ps1_char_error="!"
    export ps1_char_folder=""
    export ps1_char_monitor=""
    export ps1_char_prompt="$ "
    export ps1_char_refresh="(r)"
    export ps1_char_edit=""
    export ps1_char_user=""
    export ps1_char_cloud=""
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
    if [[ -n "${git_branch}" ]]; then
        local text_color=""
        local git_icon=""
        if [[ $(git status | grep -c 'Changes not staged for commit\|Untracked files') -gt 0 ]]; then
            text_color=${color_fg_red}
            git_icon=${ps1_char_edit}
        elif [[ $(git status | grep -c 'Changes to be committed') -gt 0 ]]; then
            text_color=${color_fg_light_yellow}
            git_icon=${ps1_char_refresh}
        elif [[ $(git status | grep -c '(use "git push" to publish your local commits)') -gt 0 ]]; then
            text_color=${color_fg_blue}
            git_icon=${ps1_char_cloud}
        else
            text_color=${color_fg_green}
            git_icon=${ps1_char_branch}
        fi
        # https://superuser.com/questions/301353/escape-non-printing-characters-in-a-function-for-a-bash-prompt/301355#301355
        printf "\001${text_color}\002${git_icon}${git_branch}"
    fi
}

# function _set_simple_prompt() {
#     PS1="$color_fg_red"'$(ps1_print_error)'\
#     "$color_fg_green$ps1_char_monitor\u "\
#     "$color_fg_light_blue$ps1_char_folder \w "\
#     "$color_fg_grey"\
#     '$(ps1_print_git_branch)'\
#     "$color_fg_reset"\
#     "$ps1_char_prompt"
# }

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
"\[$color_fg_red\]"'$(ps1_print_error)'\
"\[$color_fg_green\]$ps1_char_user\u "\
"\[$color_fg_light_blue\]$ps1_char_folder \w "\
"\[$color_fg_grey\]"\
'$(ps1_print_git_branch)'\
"\[$color_fg_reset\]"\
"$ps1_char_prompt"

# export simple_bash=_set_simple_prompt\


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
