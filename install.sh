#! /usr/bin/env bash
# ==============================================================================
# Name        : install.sh
# Version     : v0.1
# Description : wmde installation script
#
# Arguments   : N/A
# Returns     : 0 on successfull installation
#              >0 otherwise
#
# Input Files : N/A
# Output Files: N/A; messages outputed to stderr
#
# Notes       : performs simple validations based on heuristics to evaluate
#                 directory or file deletion.
#               the files / directories which are marked for deletion are 
#                 renamed with a suffix .orig_df_<yyyymmddhhmmss>
#               for example if a file named .config exists it's renamed to 
#                 .config.orig_yyyymmddhhmmss
#
# FIX         : doesnt create $destiny directories
#
# ==============================================================================
DOTFILES_DIR="${HOME}/Projects/wmde"

# configure files to deploy here
# example:
# [filetype]="action|dotfiles file|/path/to/deploy"
# action: copy link source

typeset -A file_info=(

	[xinitrc]="link|${DOTFILES_DIR}/X/xinitrc|${HOME}/.xinitrc"
	[xresources]="link|${DOTFILES_DIR}/X/Xresources|${HOME}/.Xresources"
	# add new files here
	#  TODO:: keyboard.conf needs sudo
	#[keyboard.conf]="copy|${DOTFILES_DIR}/X/00-keyboard.conf|/etc/X11/xorg.conf.d/00-keyboard.conf"
	[i3wm-config]="link|${DOTFILES_DIR}/i3wm/config|${HOME}/.config/i3/config"
	[polybar-config]="link|${DOTFILES_DIR}/polybar/config.ini|${HOME}/.config/polybar/config.ini"
	[polybar-launch]="link|${DOTFILES_DIR}/polybar/launch.sh|${HOME}/.config/polybar/launch.sh"
)

# ==============================================================================
# - Functions: -----------------------------------------------------------------
writeMessage(){

	# Description: print a formatted message to stderr
	# Arguments  : a string with the message
	# Returns
	#       - 0  : success
	#       - >0 : on error
	# Notes
	#
	printf "$0 [$$ :: $(getTimestamp full)]: ${@}\n" 1>&2
}


# ------------------------------------------------------------------------------
getTimestamp(){

	# Description: format a timestamp with current datetime
	# Arguments  : full; returns timestamp to nanosecond [yyyy-mm-dd hh:mm:ss.ns]
	#              y2s: a simple yyyymmddhhmmss for the file renaming
	# Returns    : formated timestamp
	# Notes
	#
	case "${1}" in
		"full") date +"%Y-%m-%d %T.%N"
		;;
		"y2s") date +"%Y%m%d%H%M%S"
		;;
	esac
}

# ------------------------------------------------------------------------------
copyFile(){

	# Description: copy a file; if file exists make backup
	# Arguments  : 1 file origin
	#              2 file destiny
	#       - 0  : success
	#       - >0 : error
	# Notes      : 
	#

	typeset origin="${1}"
	typeset destiny="${2}"

	writeMessage "copying file ${origin} to ${destiny}"

	backUp ${destiny}

	cp -pR ${origin} ${destiny}
}

# ------------------------------------------------------------------------------
linkFile(){

	# Description: link a file; if link exists replace it
	# Arguments  : 1 file origin
	#              2 file destiny
	#       - 0  : success
	#       - >0 : error
	# Notes      : 
	#

	typeset origin="${1}"
	typeset destiny="${2}"

	writeMessage "linking file ${origin} as ${destiny}"

	backUp ${destiny}

	ln -s ${origin} ${destiny}
}


# ------------------------------------------------------------------------------
backUp(){

	# Description: evaluates if destiny exists and make a back
	# Arguments  : 1 file destiny
	#       - 0  : success
	#       - >0 : error
	# Notes      : 
	#

	typeset destiny="${1}"

	if [ -e "${destiny}" ]; then
		writeMessage "${destiny} exists; replacing with ${origin}"
		if [ -L ${destiny} ]; then
			# if link delete
			rm ${destiny}
		else
			# if file / directory make backup
			writeMessage "backing up ${destiny} as ${destiny}_dt_$(getTimestamp y2s)"
			cp -pR ${destiny} ${destiny}_dt_$(getTimestamp y2s) && rm -rf ${destiny}
		fi
	fi
}


# ------------------------------------------------------------------------------
sourceFile(){

	# Description: source file <origin> from file <destiny>
	# Arguments  : 1 file origin
	#              2 file destiny
	#       - 0  : success
	#       - >0 : error
	# Notes      : 
	#

	typeset origin=${1}
	typeset destiny=${2}

	writeMessage "sourcing file ${origin} in ${destiny}"

	typeset msg_id="# source ${origin}"
	typeset msg_line="[ -r ${origin} ] && . ${origin}"

	if [ -f ${destiny} ]; then
		grep -q "${msg_id}" ${destiny} && return 0
	fi

	printf "\n${msg_id}\n${msg_line}\n" >> ${destiny}
}

# ------------------------------------------------------------------------------
getInstallInfo(){

	# Description: get file list, origin, destiny and methods for installation
	# Arguments  : N/A
	#       - 0  : success
	#       - >0 : on error
	# Notes      : 
	#   don't use tilde expansion
	#    methods available
	#      source - source file
	#      copy   - copy file to destiny
	#      link   - symlink file in destiny

	for file_type in ${!file_info[@]}; do

		typeset IFS="|"
		set ${file_info[$file_type]}

		typeset method="${1}"
		typeset origin="${2}"
		typeset destiny="${3}"

		case "${method}" in
			"source") sourceFile "${origin}" "${destiny}"
			;;
			"link")	linkFile "${origin}" "${destiny}"
			;;
			"copy")	copyFile "${origin}" "${destiny}"
			;;
		esac
	done
}

# ------------------------------------------------------------------------------
main(){

	# Description: runtime entry point
	# Arguments  : N/A; parses ${0} ${@}
	# Returns    : 
	#	sucess   : 0
	#	error    : parses last error received
	# Notes      : this function is an auxiliary entry point:
	#                sets process control variables;
	#                sources scripts and libaries;
	#                orchestrates the process flow.

	# start process
	writeMessage "start"

	# get files to install (link or copy)
	getInstallInfo

	# end process
	writeMessage "end"

	exit ${rc}
}


# ==============================================================================
# - Main : ---------------------------------------------------------------------
# evaluate if script is to be sourced or executed
if [ "${0}" != "bash" ]; then
	# run script
	main
else
	# source file; it's an installation script so unset functions and return error
	unset main writeMessage getTimestamp getInstallInfo sourceFile copyFile linkFile backUp
	writeMessage "this script is not aimed to be sourced!!"
	return 130
fi
