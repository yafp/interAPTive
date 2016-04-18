#!/bin/bash

# Title				:interaptive.sh
# Description		:An interactive commandline interface for APT
#											(inspired by yaourt-gui)
# Author			:yafp
# URL				:https://github.com/yafp/interAPTive/
# Date            	:20160418
# Version         	:0.3
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
appVersion="0.3 (WIP)"
appTagline=" $appName $appVersion - $appDescription - ($appURL)"



# ---------------------------------------------------------------------
# TEXT-STYLES & COLOR DEFINITIONS
# ---------------------------------------------------------------------
# styles
bold=$(tput bold)
normal=$(tput sgr0)
underline=$(tput smul)

# colors
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
	if hash apt 2>/dev/null; then # check for apt
        printf "Detected apt"
    else
		printf "${bold}${red}ERROR${normal} - Unable to find apt (errno 1)\n\n"
        exit 1
    fi
}



# ------------------------------------------------------
# PRINT HEAD
# ------------------------------------------------------
function printHead {
	lines=$(tput lines) # not in use so far
	columns=$(tput cols)
	clear

	printf "\n  _)        |               \    _ \ __ __| _)\n"
	printf "   |    \    _|   -_)   _| _ \   __/    |    | \ \ /  -_)\n"
	printf "  _| _| _| \__| \___| _| _/  _\ _|     _|   _|  \_/ \___|\n\n"

	printf "${bold}$appTagline\n"

	printf " ${green}"
	for (( c=1; c<=$columns-2; c++ ))
	do
		printf "-"
	done
	printf "${normal}\n\n"
}



# ------------------------------------------------------
# PRINT COMMAND LIST
# ------------------------------------------------------
function printCommandList {
	# Update'ing
	printf " ${bold}Update${normal}\n"
	printf "  [1] Update package list\t\t\t\t(apt update)\n"
	printf "  [2] Download and install updates\t\t\t(apt upgrade)\n"
	printf "  [3] Download and install updates & dependencies\t(apt dist-upgrade)\n\n"

	# search & info
	printf " ${bold}Info${normal}\n"
	printf "  [4] Search a package\t\t\t\t\t(apt search PKG-NAME)\n"
	printf "  [5] Show package information\t\t\t\t(apt show PKG-NAME)\n"
	printf "  [6] Show package version information\t\t\t(apt-cache policy PKG-NAME)\n"
	printf "  [7] Show installed packages\t\t\t\t(apt list --installed)\n"
	printf "  [8] Show upgradable packages\t\t\t\t(apt list --upgradable)\n"
	printf "  [9] Show all packages\t\t\t\t\t(apt list --all-versions)\n\n"

	# install
	printf " ${bold}Install${normal}\n"
	printf " [10] Install new packages by name\t\t\t(apt install PKG-NAME)\n\n"

	# remove
	printf " ${bold}Removal${normal}\n"
	printf " [11] Remove packages by name\t\t\t\t(apt remove PKG-NAME)\n"
	printf " [12] Purge packages by name\t\t\t\t(apt purge PKG-NAME)\n"
	printf " [13] Remove unneeded packages\t\t\t\t(apt-get autoremove)\n\n"

	# misc
	printf " ${bold}Misc${normal}\n"
	printf "  [L] Show apt log\t\t\t\t\t(/var/log/dpkg)\n"
	printf "  [E] Edit sources\t\t\t\t\t(apt edit-sources)\n"
	printf "  [Q] Quit\n\n"
}



# ------------------------------------------------------
# APT-LOG -
# http://linuxcommando.blogspot.de/2008/08/how-to-show-apt-log-history.html
# Check: https://github.com/blyork/apt-history for better approach
# ------------------------------------------------------
function aptLog() {
	clear
	read -p " ${green}Choose${normal} [I]nstall, [U]pgrade, [R]emove or [A]ll: " answer
	# handle the input
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
	printf "\n ${green}Press ANY key to return to the main interface ...${normal}"
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
		# handle the input
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

			[4])
				read -p " ${green}Searching for: ${normal}" search
				executeAPTCommand "apt search $search"
				;;

			[5])
				read -p " ${green}Show info for pkg: ${normal}" search
				executeAPTCommand "apt show $search"
				;;

			[6])
				read -p " ${green}Show policy for pkg: ${normal}" search
				executeAPTCommand "apt-cache policy $search"
				;;

			[7])
				executeAPTCommand "apt list --installed"
				;;

			[8])
				executeAPTCommand "apt list --upgradable"
				;;

			[9])
				executeAPTCommand "apt list --all-versions"
				;;

			10)
				read -p " ${green}Please enter a package name for installation: ${normal}" search
				if [[ $rootUser==false ]]; then
					executeAPTCommand "sudo apt install $search"
				else
					executeAPTCommand "apt install $search"
				fi
				;;

			11)
				read -p " ${green}Please enter a package name for removal: ${normal}" search
				if [[ $rootUser==false ]]; then
					executeAPTCommand "sudo apt remove $search"
				else
					executeAPTCommand "apt remove $search"
				fi
				;;

			12)
				read -p " ${green}Please enter a package name for purge: ${normal}" search
				if [[ $rootUser==false ]]; then
					executeAPTCommand "sudo apt purge $search"
				else
					executeAPTCommand "apt purge $search"
				fi
				;;

			13)
				if [[ $rootUser==false ]]; then
					executeAPTCommand "sudo apt-get autoremove"
				else
					executeAPTCommand "apt-get autoremove"
				fi
				;;

			[eE])
				if [[ $rootUser==false ]]; then
					executeAPTCommand "sudo apt edit-sources"
				else
					executeAPTCommand "apt edit-sources"
				fi
				;;

			[lL])
				aptLog
				;;

	   		[qQ])
				exit;;
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
