#!/bin/bash

# Title				:interaptive.sh
# Description		:An interactive commandline interface for APT
#											(inspired by yaourt-gui)
# Author			:yafp
# URL				:https://github.com/yafp/interAPTive/
# Date            	:20160419
# Version         	:0.5
# Usage		 		:bash interaptive.sh 	(non-installed)
#					:interaptive			(installed via Makefile)
# Notes				:None
# Bash_version    	: 4.3.11(1)-release 	(tested with)


# ------------------------------------------------------
# GENERAL DEFINITIONS
# ------------------------------------------------------
appName="interAPTive"
appDescription="An interactive commandline interface for APT"
appURL="https://github.com/yafp/interAPTive/"
appVersion="0.5 (WIP 20160420)" # 0.x (WIP YYMMDDDD) = work in progress
appTagline=" $appName - $appDescription"


# ---------------------------------------------------------------------
# TEXT-STYLES & COLOR DEFINITIONS
# ---------------------------------------------------------------------
# styles
bold=$(tput bold)
normal=$(tput sgr0)
underline=$(tput smul)

# colors
red=$(tput setaf 1)
green=$(tput setaf 2)


# ------------------------------------------------------
# CHECK FOR ROOT USAGE
# ------------------------------------------------------
function checkForRootUser() {
	if [ "$EUID" -ne 0 ]; then # current user != root
		rootUser=false
  	else # current user = root
		rootUser=true
	fi
}


# ------------------------------------------------------
# CHECK FOR APT
# ------------------------------------------------------
function checkForApt() {
	printf "Searching apt...\n\n"
	if hash apt 2>/dev/null; then # check for apt
        printf "\tDetected apt\n"
    else
		printf "${bold}${red}ERROR${normal}\tUnable to find apt (errno 1).\n\n"
		printf "\tPlease make sure you are working on a debian-based system.\n"
		printf "\tVisit $appURL to report issues.\n"
        exit 1
    fi
}


# ------------------------------------------------------
# CHECK TERMINAL WINDOW SIZE
# ------------------------------------------------------
function checkTerminalSize() {
	errorCount=0		# Reset errorCounter to 0
	minLines=41 		# Define min height
	minColumns=90 		# Define mind weight
	hideASCIIArt=false

	# check Lines/Heigth
	if (( $lines < $minLines )); then
		if (( $lines < $minLines-5 )); then
			printf " Window height ($lines) is to small (min $minLines).\n Please resize your terminal window and ...\n"
			errorCount=$((errorCount+1)) # Errorcount +1
		else # hiding ascii-art should be enough to fit to terminal-size ... so lets hide it
			hideASCIIArt=true
		fi
	fi

	# check columns
	if (( $columns < $minColumns )); then
		printf " Window width ($columns) is to small (min $minColumns).\n Please resize your terminal window and ...\n"
		errorCount=$((errorCount+1)) # Errorcount +1
	fi

	# check if errors happened - if so pause the script
	if (( $errorCount > 0 )); then
		pause
	fi
}


# ------------------------------------------------------
# PRINT HEAD
# ------------------------------------------------------
function printHead {
	clear

	lines=$(tput lines)
	columns=$(tput cols)

	# Show ASCII art only if we have enough space - otherwise skip
	if [ "$hideASCIIArt" = false ] ; then
		printf "\n  _)        |               \    _ \ __ __| _)\n"
		printf "   |    \    _|   -_)   _| _ \   __/    |    | \ \ /  -_)\n"
		printf "  _| _| _| \__| \___| _| _/  _\ _|     _|   _|  \_/ \___|\n\n"
	fi

	printf "${bold}$appTagline\n"

	printf " ${green}"
	for (( c=1; c<=$columns-2; c++ ))
	do
		printf "-"
	done
	printf "${normal}\n\n"

	checkTerminalSize
}


# ------------------------------------------------------
# PRINT COMMAND LIST
# ------------------------------------------------------
function printCommandList {
	# 1x = Update'ing
	printf " ${bold}Update${normal}\n"
	printf "  [1] Update package list\t\t\t\t(apt update)\n"
	printf "  [2] Download and install updates\t\t\t(apt upgrade)\n"
	printf "  [3] Download and install updates & dependencies\t(apt dist-upgrade)\n\n"

	# 2x = search & info
	printf " ${bold}Info${normal}\n"
	printf " [21] Search packages by name\t\t\t\t(apt search PKG-NAME)\n"
	printf " [22] Package information\t\t\t\t(apt show PKG-NAME)\n"
	printf " [23] Package version information\t\t\t(apt-cache policy PKG-NAME)\n"
	printf " [24] Changelog for single package\t\t\t(apt-get changelog PKG-NAME)\n" # Issue 13
	printf " [25] Dependencies for single package\t\t\t(apt-cache depends PKG-NAME)\n" # Issue 12
	printf " [26] List installed packages\t\t\t\t(apt list --installed)\n" # Issue 3
	printf " [27] List upgradable packages\t\t\t\t(apt list --upgradable)\n" # Issue 3
	printf " [28] List all packages\t\t\t\t\t(apt list --all-versions)\n\n" # Issue 3

	# 3x = install
	printf " ${bold}Install${normal}\n"
	printf " [31] Install new packages by name\t\t\t(apt install PKG-NAME)\n"
	printf " [32] Reinstall a packages by name\t\t\t(apt install --reinstall PKG-NAME)\n\n" # Issue 14

	# 4x = remove
	printf " ${bold}Removal${normal}\n"
	printf " [41] Remove packages by name\t\t\t\t(apt remove PKG-NAME)\n"
	printf " [42] Purge packages by name\t\t\t\t(apt purge PKG-NAME)\n" # Issue 8
	printf " [43] Remove unneeded packages\t\t\t\t(apt-get autoremove)\n\n"

	# misc
	printf " ${bold}Misc${normal}\n"
	printf "  [L] Show apt log\t\t\t\t\t(/var/log/dpkg)\n" # Issue 10
	printf "  [E] Edit sources\t\t\t\t\t(apt edit-sources)\n" # Issue 4
	printf "  [H] Help\n" # Issue
	printf "  [Q] Quit\n\n"
}


# ------------------------------------------------------
# APT-LOG -
# http://linuxcommando.blogspot.de/2008/08/how-to-show-apt-log-history.html
# Check: https://github.com/blyork/apt-history for better approach
# ------------------------------------------------------
function aptLog() {
	printHead
	read -p " ${green}Choose${normal} [I]nstall, [U]pgrade, [R]emove or [A]ll: " answer
	case $answer in
		[iI]) # install
			cat /var/log/dpkg.log | grep 'install '
			;;

		[uU]) #upgrade
			cat /var/log/dpkg.log | grep 'upgrade '
			;;

		[rR]) #remove
			cat /var/log/dpkg.log | grep 'remove '
			;;

		[aA]) # all
			cat /var/log/dpkg.log
			;;
	esac
	pause
}


# ------------------------------------------------------
# EXECUTE APT COMMAND
# ------------------------------------------------------
function executeAPTCommand() {
	printf "\n Executing ${bold}$1${normal}\n\n"
	$1
	pause
}


# ------------------------------------------------------
# PAUSE - WAIT FOR INPUT & RESTART INPUT LOOP
# ------------------------------------------------------
function pause() {
	printf "\n ${green}Press ANY key to continue ...${normal}"
	read -n 1
   	printCoreUI
}


# ------------------------------------------------------
# INPUT LOOP
# ------------------------------------------------------
function printCoreUI {
	while true
	do
		printHead			# print head
		printCommandList	# print command list

		read -p " ${green}Please enter a command number: ${normal}" answer
	  	case $answer in
			[1])
				if [[ $rootUser==false ]]; then
					executeAPTCommand "sudo apt update"
				else
					executeAPTCommand "apt update"
				fi
				;;

			[2])
				if [[ $rootUser==false ]]; then
					executeAPTCommand "sudo apt upgrade"
				else
					executeAPTCommand "apt upgrade"
				fi
				;;

			[3])
				if [[ $rootUser==false ]]; then
					executeAPTCommand "sudo apt dist-upgrade"
				else
					executeAPTCommand "apt dist-upgrade"
				fi
				;;

			21)
				read -p " ${green}Searching for: ${normal}" search
				executeAPTCommand "apt search $search"
				;;

			22)
				read -p " ${green}Show info for pkg: ${normal}" search
				executeAPTCommand "apt show $search"
				;;

			23)
				read -p " ${green}Show policy for pkg: ${normal}" search
				executeAPTCommand "apt-cache policy $search"
				;;

			24) # Introduced by Issue: #13
				read -p " ${green}Please enter a package name for changelog: ${normal}" search
				executeAPTCommand "apt-get changelog $search"
				;;

			25) # Introduced by Issue: #12
				read -p " ${green}Please enter a package name for dependencies: ${normal}" search
				executeAPTCommand "apt-cache depends $search"
				;;

			26)
				executeAPTCommand "apt list --installed"
				;;

			27)
				executeAPTCommand "apt list --upgradable"
				;;

			28)
				executeAPTCommand "apt list --all-versions"
				;;

			31)
				read -p " ${green}Please enter a package name for installation: ${normal}" search
				if [[ $rootUser==false ]]; then
					executeAPTCommand "sudo apt install $search"
				else
					executeAPTCommand "apt install $search"
				fi
				;;

			32)
				read -p " ${green}Please enter a package name for re-installation: ${normal}" search
				if [[ $rootUser==false ]]; then
					executeAPTCommand "sudo apt install --reinstall $search"
				else
					executeAPTCommand "apt install --reinstall $search"
				fi
				;;

			41)
				read -p " ${green}Please enter a package name for removal: ${normal}" search
				if [[ $rootUser==false ]]; then
					executeAPTCommand "sudo apt remove $search"
				else
					executeAPTCommand "apt remove $search"
				fi
				;;

			42)
				read -p " ${green}Please enter a package name for purge: ${normal}" search
				if [[ $rootUser==false ]]; then
					executeAPTCommand "sudo apt purge $search"
				else
					executeAPTCommand "apt purge $search"
				fi
				;;

			43)
				if [[ $rootUser==false ]]; then
					executeAPTCommand "sudo apt-get autoremove"
				else
					executeAPTCommand "apt-get autoremove"
				fi
				;;

			[eE]) # edit sources
				if [[ $rootUser==false ]]; then
					executeAPTCommand "sudo apt edit-sources"
				else
					executeAPTCommand "apt edit-sources"
				fi
				;;

			[lL]) # apt log
				aptLog
				;;

			[hH]) # help
				printHead
				printf " Name:\t\t$appName\n"
				printf " Function:\t$appDescription\n"
				printf " Version:\t$appVersion\n"
				printf " URL:\t\t$appURL\n"
				pause
				;;

	   		[qQ]) # quit
				clear
				exit;;

			*)
				#printf " ${bold}${red}ERROR${normal}\tInvalid input.\n"
				#pause
				;;
		esac
	done
}


# ------------------------------------------------------
# Script Logic
# ------------------------------------------------------
printHead 			# print script head in case of errors in checkForApt
checkForApt			# check if system has apt
checkForRootUser	# check if user is root or not
printCoreUI 		# run the input loop at start
