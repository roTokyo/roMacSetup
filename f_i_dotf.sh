#!/usr/bin/env bash

# ******************************
# *                            *
# *   Install .dots files      *
# *                            *
#*******************************
#


ORIGIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
DESTINATION="${HOME}/Desktop/test"
BASHFILES=(".bash_profile" ".bash_prompt" ".bash_aliases" ".bash_export" ".bash_functions")
GITFILES=(".gitattributes" ".gitconfig" ".gitignore")
UTILITIESPATH='zz-bin'
BIN="${HOME}/Desktop/test/bin"
VIMFILES=(".vimrc" ".vim")
OTHERFILES=(".editorconfig" ".hushlogin")


_installFiles () {
  ARRAY=("$@")
  #for file in ${ORIGIN}/.{bash_profile,bash_prompt,bash_aliases,bash_export,bash_functions}; do
  for file in ${ORIGIN}/"${ARRAY[@]}"; do
    filename="${file##*/}"
    if [[ -f ${DESTINATION}/${filename} ]] && [[ ! -L ${DESTINATION}/${filename} ]]
      then
        _f_alert_warning "File ${filename} EXISTS ... "
        seek_confirmation " ................................ do you want to backup? [yN]"
        if is_confirmed; then
          mv ${DESTINATION}/${filename}  ${DESTINATION}/${filename}.bak
          _f_alert_success "${filename} backup successfull!"
        fi
    fi

    if [[ -L ${DESTINATION}/${filename} ]]
      then
        _f_alert_warning "Symlink ${filename} EXISTS ... "
        seek_confirmation " ................................ overwrite? [yN]"
        if is_confirmed; then
          ln -sfn ${ORIGIN}/${filename} ${DESTINATION}/
          _f_alert_notice "${filename} symlink overwritten!"
        fi
    fi

    if [[ ! -f ${DESTINATION}/${filename} ]]
      then
        seek_confirmation "File ${filename} DO NOT EXISTS ... creating symlink? [yN]"
        if is_confirmed; then
          ln -s ${ORIGIN}/${filename} ${DESTINATION}/
          _f_alert_info "${filename} symlink created!"
        fi
    fi

  done
}

_installUtilities () {
  if [[ ! -d ${BIN} ]]
    then
      mkdir -p ${BIN}
      _f_alert_info "${BIN} directory created"
  fi
  for file in ${ORIGIN}/${UTILITIESPATH}; do
    #filename="${file##*/}"
    echo ${file}
    if [[ -L ${DESTINATION}/${BIN}/${filename} ]]
      then
        _f_alert_warning "Symlink ${filename} EXISTS ... "
        seek_confirmation " ................................ overwrite? [yN]"
        if is_confirmed; then
          ln -sfn ${ORIGIN}/${UTILITIESPATH}/${filename} ${DESTINATION}/${BIN}
          _f_alert_notice "${filename} symlink overwritten!"
        fi
      else
        # ln -s ${ORIGIN}/${UTILITIESPATH}/${filename} ${DESTINATION}/${BIN}
        echo ${ORIGIN}/${UTILITIESPATH}/${filename}
         _f_alert_notice "${filename} symlink created!"
    fi

  done
  read -p "$(_f_alert_input 'Press any button to CONTINUE ⧳ ')" -n 1
}


function seek_confirmation() {
  #input "$@"
  read -p "$(_f_alert_input "$@")" -n 1
  echo ""
}

function is_confirmed() {
  if [[ "${REPLY}" =~ ^[Yy]$ ]]; then
    return 0
  fi
  return 1
}

_alert() {

  ORANGE=$(tput setaf 166)
	RED=$(tput setaf 1)
	RESET=$(tput sgr0)
	TAN=$(tput setaf 3)

	if [[ "${1}" = "info" || "${1}" = "notice" ]];    then local COLOR=""; fi
	if [[ "${1}" = "input" ]];   then local COLOR="${RED}"; fi
	if [[ "${1}" = "success" ]]; then local COLOR="${TAN}"; fi
	if [[ "${1}" = "warning" ]]; then local COLOR="${RED}"; fi
	if [[ "${1}" = "menu" ]];    then local COLOR="${ORANGE}"; fi

	echo -e "${COLOR}$(printf "[%9s]" "${1}") ${MESSAGE}${RESET}"
}


_f_alert_info ()      { local MESSAGE="${*}"; echo "$(_alert info)"; }
_f_alert_input ()     { local MESSAGE="${*}"; echo "$(_alert input)"; }
_f_alert_notice ()    { local MESSAGE="${*}"; echo "$(_alert notice)"; }
_f_alert_menu()       { local MESSAGE="${*}"; echo "$(_alert menu)"; }
_f_alert_success ()   { local MESSAGE="${*}"; echo "$(_alert success)"; }
_f_alert_warning ()   { local MESSAGE="${*}"; echo "$(_alert warning)"; }

_byby() {
  cat <<_EOF_

[     exit]

_EOF_
	#read -p "$(_f_alert_input 'Press any button to EXIT ⧳ ')" -n 1
	unset ORIGIN DESTINATION BASHFILES GITFILES VIMFILES OTHERFILES
	clear
	exit
}


_menu () {

	local readonly DELAY=2

	while [[ $REPLY != 0 ]]; do
		clear && echo ''
  	cat <<_EOF_
  Extra file installation routine:
    1. Install Bash Dot Files
    2. Install Git Profile Files
    3. Install Vim Profile Files (NOT READY YET)
    4. Install Other Profile Files
    5. Install Utilities Files

    A. All

    0. eXit

_EOF_
  	read -p "Enter selection [0-5] > "
  	if [[ $REPLY =~ ^[0-5]$ || $REPLY =~ ^[A]$ ]]; then
    	if [[ $REPLY == 0 ]]; then
        echo ''; _f_alert_menu '  eXit Installation Routine! Wait ...'; echo ''
      	sleep $DELAY
				clear
    	fi
			if [[ $REPLY == 'A' ]]; then
				clear
        echo '';  _f_alert_menu '  1. Install Bash Dot Files '; echo ''
      	_installFiles "${BASHFILES[@]}"
        echo '';  _f_alert_menu '  2. Install Git Profile Files '; echo ''
        _installFiles "${GITFILES[@]}"
        echo '';  _f_alert_menu '  3. NOT READY YET  '; echo ''
        SLEEP ${DELAY}
        echo ''; _f_alert_menu '  4. Install Other Profile Files '; echo ''
        _installFiles "${OTHERFILES[@]}"
    	fi
    	if [[ $REPLY == 1 ]]; then
        clear
      	echo '';  _f_alert_menu '  1. Install Bash Dot Files '; echo ''
      	_installFiles "${BASHFILES[@]}"
    	fi
    	if [[ $REPLY == 2 ]]; then
        clear
      	echo '';  _f_alert_menu '  2. Install Git Profile Files '; echo ''
        _installFiles "${GITFILES[@]}"
    	fi
    	if [[ $REPLY == 3 ]]; then
    		clear
        echo '';  _f_alert_menu '  3. NOT READY YET  '; echo ''
        sleep ${DELAY}
    	fi
    	if [[ $REPLY == 4 ]]; then
        clear
        echo ''; _f_alert_menu '  4. Install Other Profile Files '; echo ''
        _installFiles "${OTHERFILES[@]}"
    	fi
    	if [[ $REPLY == 5 ]]; then
        clear
        echo ''; _f_alert_menu '  5. Install Utilities Files '; echo ''
        _installUtilities
    	fi
    	else
        _f_alert_warning '  Invalid entry! Wait ...'
      	sleep $DELAY
  	fi
	done
  unset DELAY REPLY
}




_menu
_byby
