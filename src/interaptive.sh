#!/bin/bash

# Function: Offering a simple apt-gui inspired by yaourt-gui


# ------------------------------------------------------
# GENERAL DEFINITIONS
# ------------------------------------------------------
appName="interAPTive"
appDescription="An interactive commandline interface for APT"
version="0.2"

tagline="$appName $version - $appDescription"



# ---------------------------------------------------------------------
# ENVIRONMENT & COLOR DEFINITIONS
# ---------------------------------------------------------------------
# format
bold=$(tput bold)
normal=$(tput sgr0)
underline=$(tput smul)

# colors
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)



# ------------------------------------------------------
# CHECK FOR ROOT USAGE
# ------------------------------------------------------
function checkForRootUser() {
	if [ "$EUID" -ne 0 ]; then
		rootUser=false
  	else
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
	lines=$(tput lines)
	columns=$(tput cols)
	clear

	printf "\n"
	printf " _)        |               \    _ \ __ __| _)\n"
	printf "  |    \    _|   -_)   _| _ \   __/    |    | \ \ /  -_)\n"
	printf " _| _| _| \__| \___| _| _/  _\ _|     _|   _|  \_/ \___|\n\n"

	printf "${bold}"
	printf "%*s\n" $(((${#tagline}+$columns)/2)) "$tagline"
	printf "${normal}"

	printf "\e[42m" # switch to green background
	printf "\e[30m" # switch to black foreground
	for (( c=1; c<=$columns; c++ ))
	do
		printf " "
	done
	printf "\e[49m" # switch back to default background
	printf "\e[39m\n\n" #  switch back to default foreground

	# http://misc.flogisoft.com/bash/tip_colors_and_formatting
}



# ------------------------------------------------------
# PRINT COMMAND LIST
# ------------------------------------------------------
function printCommandList {
	# Updateing
	printf "  [1] Fetch package list (apt update)\n"
	printf "  [2] Download and install updates (apt upgrade)\n"
	printf "  [3] Download and install the updates and install new neessary packages (apt dist-upgrade)\n\n"
	# search & info
	printf "  [4] Search a package (apt search PACKAGENAME)\n"
	printf "  [5] Show package information (apt show PACKAGENAME)\n"
	printf "  [6] Show package version information (apt-cache policy PACKAGENAME)\n\n"
	# install or remove
	printf "  [7] Install new package (apt install PACKAGENAME)\n"
	printf "  [8] Remove a package (apt remove PACKAGENAME)\n"
	printf "  [9] Remove unneeded packages (apt-get autoremove)\n\n"
	# misc
	printf " [10] Show installed packages (apt list --installed)\n"
	printf " [11] Show installed packages (apt list --upgradable)\n"
	printf " [12] Show installed packages (apt list --all-versions)\n\n"
	# admin
	printf "  [E] Edit sources (apt edit-sources)\n\n"
	# quit
	printf "  [Q] Quit\n\n"
}



# ------------------------------------------------------
# EXECUTE APT COMMAND
# ------------------------------------------------------
function executeAPTCommand() {
	# check if user is root or not - if not add sudo before command if needed
	printf "\nExecuting ${bold}$1${normal}\n\n"
	$1
	pause
}



# ------------------------------------------------------
# PAUSE - WAIT FOR INPUT & RESTART INPUT LOOP
# ------------------------------------------------------
function pause() {
	printf "\n${green}Press ANY key to return to the main interface ...${normal}"
   	read -p "$*"
   	newInputLoop
}



# ------------------------------------------------------
# INPUT LOOP
# ------------------------------------------------------
function newInputLoop {
	while true
	do
		printHead			# print head
		printCommandList	# print command list

		read -p "${green}Please enter a command number: ${normal}" answer
		# handle the input
	  	case $answer in
			[1])
				if [[ $rootUser==false ]]; then
					executeAPTCommand "sudo apt update"
				else
					executeAPTCommand "apt update"
				fi
				break;;

			[2])
				if [[ $rootUser==false ]]; then
					executeAPTCommand "sudo apt upgrade"
				else
					executeAPTCommand "apt upgrade"
				fi
				break;;

			[3])
				if [[ $rootUser==false ]]; then
					executeAPTCommand "sudo apt dist-upgrade"
				else
					executeAPTCommand "apt dist-upgrade"
				fi
				break;;

			[4])
				read -p "${green}Please enter a search string: ${normal}" search
				executeAPTCommand "apt search $search"
				break;;

			[5])
				read -p "${green}Please enter a package name: ${normal}" search
				executeAPTCommand "apt show $search"
				break;;

			[6])
				read -p "${green}Please enter a package name: ${normal}" search
				executeAPTCommand "apt-cache policy $search"
				break;;

			[7])
				read -p "${green}Please enter a package name for installation: ${normal}" search
				if [[ $rootUser==false ]]; then
					executeAPTCommand "sudo apt install $search"
				else
					executeAPTCommand "apt install $search"
				fi
				break;;

			[8])
				read -p "${green}Please enter a package name for removal: ${normal}" search
				if [[ $rootUser==false ]]; then
					executeAPTCommand "sudo apt remove $search"
				else
					executeAPTCommand "apt remove $search"
				fi
				break;;

			[9])
				if [[ $rootUser==false ]]; then
					executeAPTCommand "sudo apt-get autoremove"
				else
					executeAPTCommand "apt-get autoremove"
				fi
				break;;

			10)
				executeAPTCommand "apt list --installed"
				break;;

			11)
				executeAPTCommand "apt list --upgradable"
				break;;

			11)
				executeAPTCommand "apt list --all-versions"
				break;;

			[eE])
				if [[ $rootUser==false ]]; then
					executeAPTCommand "sudo apt edit-sources"
				else
					executeAPTCommand "apt edit-sources"
				fi
				break;;

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
newInputLoop 		# run the input loop at start
