#!/bin/bash

export color_fg_reset='\033[0m'
export color_fg_green='\033[0;49;32m'
export color_fg_yellow='\033[0;49;33m'
export color_fg_light_blue='\033[0;49;36m'
export color_fg_white='\033[0;49;37m'
export color_fg_grey='\033[0;49;90m'
export color_fg_red='\033[0;49;91m'
export color_fg_purple='\033[0;49;94m'

function i_color_codes_1()
{
	local clbg
	local clfg
	local attr

	#Background
	for clbg in {40..47} {100..107} 49 ; do
		#Foreground
		for clfg in {30..37} {90..97} 39 ; do
			#Formatting
			for attr in 0 1 2 4 5 7 ; do
				#Print the result
				echo -en "\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \e[0m"
			done
			echo #Newline
		done
	done
}

function i_color_codes_2()
{
	local i
	for i in {0..255} ; do
		printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i"
		if (( i == 15 )) || (( i > 15 )) && (( (i-15) % 6 == 0 )); then
			printf "\n";
		fi
	done
}
