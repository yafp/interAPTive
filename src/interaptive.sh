#!/bin/bash

# Title                 :interaptive.sh
# Description           :An interactive commandline interface for APT (inspired by yaourt-gui)
# Author                :yafp
# URL                   :https://github.com/yafp/interAPTive/
# Date                  :20161219
# Version               :2.0
# Usage                 :bash interaptive.sh        (non-installed)
#                       :interaptive                (installed via Makefile)
# Notes                 :None
# Bash_version          :4.3.14                     (tested with)
# Requirements:
# - whiptail
# - curl
# - apt


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# URLs & other developer notes
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Whiptail Examples:
# http://xmodulo.com/create-dialog-boxes-interactive-shell-script.html
#
# Whiptail Color Usage
# http://askubuntu.com/questions/776831/whiptail-change-background-color-dynamically-from-magenta
#
# Yes & OK      = 0
# No & Cancel   = 1



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Developer/Debug Notes
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Code stepping:
#    Enable code stepping by placing the following cmd at the place you want to start debugging:
#         trap '(read -p "[$BASH_SOURCE:$LINENO] $BASH_COMMAND?")' DEBUG



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CONSTANTS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# general stuff
readonly APP_VERSION="2.0.20161219.01"
readonly APP_VERSION_URL="https://raw.githubusercontent.com/yafp/interAPTive/master/version"
readonly APP_PROJECT_URL="https://github.com/yafp/interAPTive/"
readonly APP_LICENSE="GPL3"
readonly APP_NAME_DESCRIPTION="interAPTive - $APP_VERSION - an interactive commandline interface for APT ($APP_LICENSE)"

# version 2
readonly APP_NAME_SHORT="interAPTive"
readonly APP_PATH_FULL="/usr/bin/interaptive" # if 'installed' via makefile
readonly APP_DOWNLOAD_URL="https://raw.githubusercontent.com/yafp/interAPTive/master/src/interaptive.sh"

# version 1 - aka - classic
readonly APP_CLASSIC_NAME_SHORT="interAPTive-classic"
readonly APP_CLASSIC_PATH_FULL="/usr/bin/interaptive-classic" # if 'installed' via makefile
readonly APP_CLASSIC_DOWNLOAD_URL="https://raw.githubusercontent.com/yafp/interAPTive/master/src/interaptive-classic.sh"



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CONFIG WHIPTAIL-SIZES
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# menu
readonly DEFAULT_MENU_HEIGHT=16
readonly DEFAULT_MENU_WIDTH=70
readonly DEFAULT_MENU_LIST_HEIGHT=5
#
# questions/msgbox
readonly DEFAULT_DIALOG_HEIGHT=10
readonly DEFAULT_DIALOG_WIDTH=60



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# SELFUPDATE
#
# Function:
# - Checks online for interaptive updates
# - Offers option to update the local interaptive installation
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
selfUpdate() 
{
    printHead
    printf " Starting selfupdate...\n"
    printf " Searching curl\t\t\t"
    if hash curl 2>/dev/null; then # curl is installed - continue with selfupdate
        printf "%s%sPASSED%s\n" "${bold}" "${green}" "${normal}"

        curl -o /tmp/interaptive_version $APP_VERSION_URL # download version file to compare local vs online version
        APP_VERSION_LATEST=$(cat /tmp/interaptive_version)

        if [[ "$APP_VERSION_LATEST" == "Not Found" ]]; then
            printf " Fetching update information\t%s%sFAILED%s\n" "${bold}" "${red}" "${normal}"
            printError "2" "Unable to fetch version informations (${background}$APP_VERSION_URL${normal}) ... aborting"
            pause
            return
        else # was able to fetch the version file online via curl
            printf " Fetching update information\t%s%sPASSED%s\n" "${bold}" "${green}" "${normal}"
            printf "\n Installed:\t\t\t%s\n" "$APP_VERSION"
            printf " Online:\t\t\t%s\n\n" "$APP_VERSION_LATEST"
            if [[ $APP_VERSION_LATEST > $APP_VERSION ]]; then # found updates
                printf " Found newer version\n"
                # check if script was installed on expected location
                if hash "$APP_PATH_FULL" 2>/dev/null; then # check for installed version of this script
                    printf " Detected installed version of %s%s%s at %s%s%s\n\n" "${bold}" "$APP_NAME_SHORT" "${normal}" "${bold}" "$APP_PATH_FULL" "${normal}"

                    # Ask if user wants to upgrade
                    read -p " ${green}Do you really want to update ${bold}$APP_NAME_SHORT${normal}${green} to the latest version? [${normal}Y${green}]es or ANY other key to cancel: ${normal}" answer
                      case $answer in
                        [yY])
                            # get latest version of v2
                            curl -o /tmp/interaptive.sh $APP_DOWNLOAD_URL
                            printf " Finished downloading latest version of %s%s%s\n" "${bold}" "$APP_NAME_SHORT" "${normal}"
                            # replace installed copy with new version
                            if [[ $IS_ROOT_USER == false ]]; then
                                sudo cp /tmp/interaptive.sh $APP_PATH_FULL
                            else
                                cp /tmp/interaptive.sh $APP_PATH_FULL
                            fi
                            printf " Finished replacing %s%s%s at %s%s%s\n" "${bold}" "$APP_NAME_SHORT" "${normal}" "${bold}" "$APP_PATH_FULL" "${normal}"
                            
                            # get latest version of v1
                            curl -o /tmp/interaptive.sh $APP_CLASSIC_DOWNLOAD_URL
                            printf " Finished downloading latest classic version of %s%s%s\n" "${bold}" "$APP_CLASSIC_NAME_SHORT" "${normal}"
                            # replace installed copy with new version
                            if [[ $IS_ROOT_USER == false ]]; then
                                sudo cp /tmp/interaptive-classic.sh $APP_CLASSIC_PATH_FULL
                            else
                                cp /tmp/interaptive.sh $APP_CLASSIC_PATH_FULL
                            fi
                            printf " Finished replacing %s%s%s at %s%s%s\n" "${bold}" "$APP_CLASSIC_NAME_SHORT" "${normal}" "${bold}" "$APP_CLASSIC_PATH_FULL" "${normal}"
                            
                            printf " You need to restart %s%s%s now to finish the update\n" "${bold}" "$APP_NAME_SHORT" "${normal}"
                            printf "\n %sPress ANY key to quit %s%s%s" "${green}" "${bold}" "$APP_NAME_SHORT" "${normal}"
                            read -n 1
                            clear
                            printf " Bye\n\n"
                            exit
                            ;;
                    esac
                else
                    printf " %s%sERROR%s Unable to find installed version of %s%s%s at %s%s%s (errno 1).\n\n" "${bold}" "${red}" "${normal}" "${bold}" "$APP_NAME_SHORT" "${normal}" "${bold}" "$APP_PATH_FULL" "${normal}"
                    printf " %s%sERROR%s Unable to find installed version of %s%s%s at %s%s%s (errno 1).\n\n" "${bold}" "${red}" "${normal}" "${bold}" "$APP_CLASSIC_NAME_SHORT" "${normal}" "${bold}" "$APP_PATH_FULL" "${normal}"
                    printf " Visit %s%s%s to report issues.\n" "${bold}" "$APP_PROJECT_URL" "${normal}"
                    exit 1
                fi
            else # there are no updates available because:
                if [[ $APP_VERSION_LATEST < $APP_VERSION ]]; then # user has dev build
                    printf " You are using a development version, nothing to do here.\n"
                else # user is using latest official version
                    printf " You are already using the latest official version\n"
                fi
            fi
        fi
    else # Curl is not installed -> can't check for updates
        printf "%s%sFAILED%S\n" "${bold}" "${red}" "${normal}"
        printError "3" "Unable to find curl ... aborting"
    fi
    pause
}



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# RANDOM QUOTES
#
# Function:
# - Displays a random developer quote on app-exit
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
showRandomDeveloperQuote()
{
    # Random Notes array
    #
    devQuote[0]="Prolific developers don't always write a lot of code, instead they solve a lot of problems. The two things are not the same."
    devQuote[1]="Prolific programmers contribute to certain disaster."
    devQuote[2]="Without requirements or design, programming is the art of adding bugs to an empty text file.\n\n\t${background}Louis Srygley${normal}"
    devQuote[3]="Deleted code is debugged code."
    devQuote[4]="There is no programming language–no matter how structured–that will prevent programmers from making bad programs."
    devQuote[5]="The gap between theory and practice is not as wide in theory as it is in practice"
    devQuote[6]="Good design adds value faster than it adds cost."
    devQuote[7]="Errors should never pass silently. Unless explicitly silenced."
    devQuote[8]="Reusing pieces of code is liked picking off sentences from other people's stories and trying to make a magazine article.\n\n\t${background}Bob Frankston${normal}"
    devQuote[9]="Any code of your own that you haven't looked at for six or more months might as well have been written by someone else.\n\n\t${background}Eagleson's law${normal}"
    devQuote[10]="When debugging, novices insert corrective code; experts remove defective code.\n\n\t${background}Richard Pattis${normal}"
    devQuote[11]="One of my most productive days was throwing away 1000 lines of code.\n\n\t${background}Ken Thompson${normal}" 
    devQuote[12]="If the code and the comments disagree, then both are probably wrong.\n\n\t${background}Norm Schryer${normal}"
    devQuote[13]="As a rule, software systems do not work well until they have been used, and have failed repeatedly, in real applications.\n\n\t${background}David Parnas${normal}"
    devQuote[14]="The most important single aspect of software development is to be clear about what you are trying to build.\n\n\t${background}Bjarne Stroustrup${normal}"
    devQuote[15]="Code formatting is about communication, and communication is the professional developer’s first order of business.\n\n\t${background}Robert C. Martin${normal}"
    devQuote[16]="Programming is the art of doing one thing at a time.\n\n\t${background}Michael Feathers${normal}"
    devQuote[17]="Sometimes it pays to stay in bed on Monday, rather than spending the rest of the week debugging Monday's code.\n\n\t${background}Christopher Thompson${normal}"
    devQuote[18]="In programming the hard part isn’t solving problems, but deciding what problems to solve.\n\n\t${background}Paul Graham${normal}"
    devQuote[19]="A programmer is a device for turning caffeine into code.\n\n\t${background}Paul Erdos${normal}"


    # Select a random quote
    rand=$((RANDOM %  ${#devQuote[@]}))
    #rand=$((RANDOM % 8))
    
    # Display random quote
    printf " ${devQuote[$rand]}\n\n"

    # exit application
    exit
}



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# REQUIREMENTS
#
# Function:
# - Checks for packages required by interaptive
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
checkRequirements()
{
    # whiptail - error
    #
    if hash whiptail 2>/dev/null; then # check for whiptail
        :
    else
        echo "whiptail is missing, aborting now"
        exit
    fi
    
    # apt - error
    #
    if hash apt 2>/dev/null; then # check for apt
        :
    else
        echo "apt is missing, aborting now"
        exit
    fi
    
    # curl - warning
    #
    if hash curl 2>/dev/null; then # check for apt
        :
    else
        echo "curl is missing, but needed for selfupdate."

    fi
}



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# PAUSE
#
# Function:
# - Pauses the script
# - Forces the user to press a key
# - loads the matching next menu
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
pause()
{
    printf "\n %sPress ANY key to continue%s" "${green}" "${normal}"
    read -n 1
    
    if [ -z $1 ]; then  
        displayMainMenu # jump back to CoreMenu (fallback)
    else 
        $1 # if supplised - jump to the menu in question
    fi
}



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  CHECK DISTRIBUTION
#
# Function:
# - Checks the linux distribution used at application start
# - displays warnings if executed on untested and/or unsupported distributions
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
checkForLinuxDistribution()
{
    if hash lsb_release 2>/dev/null; then # check for lsb_release
        curDistri=$(lsb_release -i)

        # Check if it is an unsupported linux version
        if [[ $curDistri != *"Ubuntu"* ]] && [[ $curDistri != *"Debian"* ]] ; then
        
            # check if apt exists
            if hash apt 2>/dev/null; then # check for apt
                whiptail --title "WARNING - Unsupported Distribution" --backtitle "$APP_NAME_DESCRIPTION" --msgbox "You are using $APP_NAME_SHORT on an unsupported system. Feel free to use it anyways, but expect issues." 10 $DEFAULT_MENU_WIDTH
            else # unsupported distri and no apt -> exit
                whiptail --title "ERROR - Unsupported Distribution" --backtitle "$APP_NAME_DESCRIPTION" --msgbox "You are using $APP_NAME_SHORT on an unsupported system without apt. Aborting now" 0 0
                exit
            fi
        fi
    fi
}



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# LOG
#
# Function:
# - Gives access to the dpkg log
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dpkgLog()
{
    printHead
    printf " You are going to load the dpkg log (/var/log/dpkg).\n Select one of the following options:\n\n"
    printf " [%sI%s]nstall\n [%sU%s]pgrade\n [%sR%s]emove\n [%sA%s]ll\t\t[default]\n\n" "${green}" "${normal}" "${green}" "${normal}" "${green}" "${normal}" "${green}" "${normal}"
    read -p " ${green}Please choose: ${normal}" answer
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
            cat /var/log/dpkg.log | less
            ;;
        "") # all
            cat /var/log/dpkg.log | less
            ;;
        *) # catch all other input as invalid
            printf "\n Invalid input, aborting\n"
            ;;
    esac
    pause
}



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# MENU: Main
#
# Function:
# - displays the main menu
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
displayMainMenu()
{
    OPTION=$(whiptail --title "$APP_NAME_SHORT" --backtitle "$APP_NAME_DESCRIPTION" --ok-button "Choose" --cancel-button "Exit" --menu "Main" $DEFAULT_MENU_HEIGHT $DEFAULT_MENU_WIDTH $DEFAULT_MENU_LIST_HEIGHT \
    "1" "Maintenance" \
    "2" "Information" \
    "3" "Install" \
    "4" "Uninstall" \
    "5" "Settings"  3>&1 1>&2 2>&3)
     
    EXITSTATUS=$?
    if [ $EXITSTATUS = 0 ]; then
        case $OPTION in
            1)
                displayMaintenanceMenu
                ;;
            2)
                displayInfoMenu
                ;;
            3) 
                displayInstallMenu
                ;;
            4)
                displayUninstallMenu
                ;;
            5) 
                displaySettingsMenu
                ;;
        esac
    else
        printHead
        showRandomDeveloperQuote
    fi
}



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  MENU: MAINTENANCE
#
# Function:
# - displays the maintenance menu
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
displayMaintenanceMenu()
{
    OPTION=$(whiptail --title "$APP_NAME_SHORT" --backtitle "$APP_NAME_DESCRIPTION" --ok-button "Choose" --cancel-button "Back" --menu "Maintenance" $DEFAULT_MENU_HEIGHT $DEFAULT_MENU_WIDTH 7 \
    ".." "" \
    "Update package informations" "(sudo apt update)" \
    "Upgrade installed packages" "(sudo apt upgrade)" \
    "Clean" "(sudo apt clean)" \
    "Autoclean" "(sudo apt autoclean)" \
    "Autoremove unneeded packages" "(sudo apt autoremove)" \
    "Edit apt sources" "(sudo apt edit-sources)" 3>&1 1>&2 2>&3)
     
    EXITSTATUS=$?
    if [ $EXITSTATUS = 0 ]; then
        case $OPTION in
            "..")
                displayMainMenu # jump back to CoreMenu
                ;;
                
            "Update package informations")
                executeCommand "displayMaintenanceMenu" "apt update" "sudo"
                ;;
                
            "Upgrade installed packages")
                executeCommand "displayMaintenanceMenu" "apt upgrade" "sudo"
                ;;
                
            "Clean")
                executeCommand "displayMaintenanceMenu" "apt clean" "sudo"
                ;;
                
            "Autoclean")
                executeCommand "displayMaintenanceMenu" "apt autoclean" "sudo"
                ;;
                
            "Autoremove unneeded packages")
                executeCommand "displayMaintenanceMenu" "apt autoremove" "sudo"
                ;;
                
            "Edit apt sources")
                executeCommand "displayMaintenanceMenu" "apt edit-sources" "sudo"
                ;;
        esac
    else
        displayMainMenu # jump back to CoreMenu
    fi
}



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# MENU: INFO
#
# Function:
# - displays the info menu
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
displayInfoMenu()
{
    OPTION=$(whiptail --title "$APP_NAME_SHORT" --backtitle "$APP_NAME_DESCRIPTION" --ok-button "Choose" --cancel-button "Back" --menu "Info" $DEFAULT_MENU_HEIGHT $DEFAULT_MENU_WIDTH 8 \
    ".." "" \
    "Show dpkg log" "(/var/log/dpkg)" \
    "Search package" "(apt search)" \
    "Show package information" "(apt show)" \
    "Show package version information" "(apt-cache policy)" \
    "Show package changelog" "(apt-get changelog)"  \
    "Show package dependencies" "(apt-cache depends)"  \
    "Show package list" "(apt list)"  3>&1 1>&2 2>&3)
     
    EXITSTATUS=$?
    if [ $EXITSTATUS = 0 ]; then
        case $OPTION in
            "..")
                displayMainMenu # jump back to CoreMenu
                ;;
                
            "Show dpkg log")
                dpkgLog
                ;;
                
            "Search package")
                SEARCH_STRING=$(whiptail --title "$APP_NAME_SHORT" --backtitle "$APP_NAME_DESCRIPTION" --inputbox "Please insert a search phrase" $DEFAULT_DIALOG_HEIGHT $DEFAULT_DIALOG_WIDTH 3>&1 1>&2 2>&3)
                EXITSTATUS=$?
                if [ $EXITSTATUS = 0 ]; then
                    executeCommand "displayInfoMenu" "apt search $SEARCH_STRING"
                else
                    displayInfoMenu
                fi
                ;;
                
            "Show package information")
                SEARCH_STRING=$(whiptail --title "$APP_NAME_SHORT" --backtitle "$APP_NAME_DESCRIPTION" --inputbox "Please insert a package name" $DEFAULT_DIALOG_HEIGHT $DEFAULT_DIALOG_WIDTH 3>&1 1>&2 2>&3)
                EXITSTATUS=$?
                if [ $EXITSTATUS = 0 ]; then
                    executeCommand "displayInfoMenu" "apt show $SEARCH_STRING"
                else
                    displayInfoMenu
                fi
                ;;
                
            "Show package version information")
                SEARCH_STRING=$(whiptail --title "$APP_NAME_SHORT" --backtitle "$APP_NAME_DESCRIPTION" --inputbox "Please insert a package name" $DEFAULT_DIALOG_HEIGHT $DEFAULT_DIALOG_WIDTH 3>&1 1>&2 2>&3)
                EXITSTATUS=$?
                if [ $EXITSTATUS = 0 ]; then
                    executeCommand "displayInfoMenu" "apt-cache policy $SEARCH_STRING"
                else
                    displayInfoMenu
                fi
                ;;
                
            "Show package changelog")
                SEARCH_STRING=$(whiptail --title "$APP_NAME_SHORT" --backtitle "$APP_NAME_DESCRIPTION" --inputbox "Please insert a package name" $DEFAULT_DIALOG_HEIGHT $DEFAULT_DIALOG_WIDTH 3>&1 1>&2 2>&3)
                EXITSTATUS=$?
                if [ $EXITSTATUS = 0 ]; then
                    executeCommand "displayInfoMenu" "apt-get changelog $SEARCH_STRING"
                else
                    displayInfoMenu
                fi
                ;;
                
            "Show package dependencies")
                SEARCH_STRING=$(whiptail --title "$APP_NAME_SHORT" --backtitle "$APP_NAME_DESCRIPTION" --inputbox "Please insert a package name" $DEFAULT_DIALOG_HEIGHT $DEFAULT_DIALOG_WIDTH 3>&1 1>&2 2>&3)
                EXITSTATUS=$?
                if [ $EXITSTATUS = 0 ]; then
                    executeCommand "displayInfoMenu" "apt-cache depends $SEARCH_STRING"
                else
                    displayInfoMenu
                fi
                ;;
                
            "Show package list")
                OPTION=$(whiptail --title "$APP_NAME_SHORT" --backtitle "$APP_NAME_DESCRIPTION" --ok-button "Choose" --cancel-button "Back" --menu "Info" $DEFAULT_MENU_HEIGHT $DEFAULT_MENU_WIDTH $DEFAULT_MENU_LIST_HEIGHT \
                "<-- Back" "" \
                "Installed" "(apt list --installed)" \
                "Upgradeable" "(apt list --upgradeable)" \
                "All" "(apt list --all-versions)"  3>&1 1>&2 2>&3)

                EXITSTATUS=$?
                if [ $EXITSTATUS = 0 ]; then
                    case $OPTION in
                        "<-- Back")
                            displayInfoMenu
                            ;;
                            
                        "Installed")
                            executeCommand "displayInfoMenu" "apt list --installed"
                            ;;
                            
                        "Upgradeable")
                            executeCommand "displayInfoMenu" "apt list --upgradeable"
                            ;;
                            
                        "All")
                            executeCommand "displayInfoMenu" "apt list --all-versions"
                            ;;
                    esac
                else
                    displayInfoMenu
                fi

        esac
    else
        displayMainMenu # jump back to CoreMenu
    fi
}



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  MENU: INSTALL
#
# Function:
# - displays the install menu
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
displayInstallMenu()
{
    OPTION=$(whiptail --title "$APP_NAME_SHORT" --backtitle "$APP_NAME_DESCRIPTION" --ok-button "Choose" --cancel-button "Back" --menu "Install" $DEFAULT_MENU_HEIGHT $DEFAULT_MENU_WIDTH $DEFAULT_MENU_LIST_HEIGHT \
    ".." "" \
    "Install" "(sudo apt install)" \
    "Re-Install" "(sudo apt install --reinstall)"  3>&1 1>&2 2>&3)
     
    EXITSTATUS=$?
    if [ $EXITSTATUS = 0 ]; then
        case $OPTION in
            "..")
                displayMainMenu # jump back to CoreMenu
                ;;
                
            "Install")
                SEARCH_STRING=$(whiptail --title "$APP_NAME_SHORT" --backtitle "$APP_NAME_DESCRIPTION" --inputbox "Please insert a package name" $DEFAULT_DIALOG_HEIGHT $DEFAULT_DIALOG_WIDTH 3>&1 1>&2 2>&3)
                EXITSTATUS=$?
                if [ $EXITSTATUS = 0 ]; then
                    executeCommand "displayInstallMenu" "apt install $SEARCH_STRING" "sudo"
                else
                    displayInstallMenu
                fi
                ;;
                
            "Re-Install")
                SEARCH_STRING=$(whiptail --title "$APP_NAME_SHORT" --backtitle "$APP_NAME_DESCRIPTION" --inputbox "Please insert a package name" $DEFAULT_DIALOG_HEIGHT $DEFAULT_DIALOG_WIDTH 3>&1 1>&2 2>&3)
                EXITSTATUS=$?
                if [ $EXITSTATUS = 0 ]; then
                    executeCommand "displayInstallMenu" "apt install --reinstall $SEARCH_STRING" "sudo"
                else
                    displayInstallMenu
                fi
                ;;
        esac
    else
        displayMainMenu # jump back to CoreMenu
    fi
}



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  MENU: UNINSTALL
#
# Function:
# - displays the uninstall menu
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
displayUninstallMenu()
{
    OPTION=$(whiptail --title "$APP_NAME_SHORT" --backtitle "$APP_NAME_DESCRIPTION" --ok-button "Choose" --cancel-button "Back" --menu "Uninstall" $DEFAULT_MENU_HEIGHT $DEFAULT_MENU_WIDTH $DEFAULT_MENU_LIST_HEIGHT \
    ".." ""  \
    "Remove package" "(sudo apt remove)"  \
    "Purge package" "(sudo apt purge)"  3>&1 1>&2 2>&3)
     
    EXITSTATUS=$?
    if [ $EXITSTATUS = 0 ]; then
        case $OPTION in
            "..")
                displayMainMenu # jump back to CoreMenu
                ;;
                
            "Remove package")
                SEARCH_STRING=$(whiptail --title "$APP_NAME_SHORT" --backtitle "$APP_NAME_DESCRIPTION" --inputbox "Please insert a package name" 10 60 3>&1 1>&2 2>&3)
                EXITSTATUS=$?
                if [ $EXITSTATUS = 0 ]; then
                    executeCommand "displayUninstallMenu" "apt remove $SEARCH_STRING" "sudo"
                else
                    displayUninstallMenu
                fi
                ;;
                
            "Purge package")
                SEARCH_STRING=$(whiptail --title "$APP_NAME_SHORT" --backtitle "$APP_NAME_DESCRIPTION" --inputbox "Please insert a package name" 10 60 3>&1 1>&2 2>&3)
                EXITSTATUS=$?
                if [ $EXITSTATUS = 0 ]; then
                    executeCommand "displayUninstallMenu" "apt purge $SEARCH_STRING" "sudo"
                else
                    displayUninstallMenu
                fi
                ;;
        esac
    else
        displayMainMenu # jump back to CoreMenu
    fi
}



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# MENU: SETTINGS
#
# Function:
# - displays the settings menu
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
displaySettingsMenu()
{
    OPTION=$(whiptail --title "$APP_NAME_SHORT" --backtitle "$APP_NAME_DESCRIPTION" --ok-button "Choose" --cancel-button "Back" --menu "Settings" $DEFAULT_MENU_HEIGHT $DEFAULT_MENU_WIDTH $DEFAULT_MENU_LIST_HEIGHT \
    ".." "" \
    "Selfupdate" "" \
    "Github" "($APP_PROJECT_URL)" 3>&1 1>&2 2>&3)
     
    EXITSTATUS=$?
    if [ $EXITSTATUS = 0 ]; then
        case $OPTION in
            "..")
                displayMainMenu # jump back to CoreMenu
                ;;
                
            "Selfupdate")
                selfUpdate
                ;;
                
            "Github")
                xdg-open "$APP_PROJECT_URL"
                displayMainMenu
        esac
    else
        displayMainMenu # jump back to CoreMenu
    fi
}



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# PRINT HEAD
#
# Function:
# - prints an interaptive ascii-art for terminal outputs
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function printHead() 
{
    errorCount=0            # Init errorCounter to 0
    showASCIIArt=false        # Set a default value for boolean (assuming window is to small)

    # Height
    minLines=20             # Define min height (+5 for full ASCII-art)
    curLines=$(tput lines)    # get lines of current terminal window
    errorLinesHeight=""

    # Width
    minColumns=$DEFAULT_MENU_WIDTH             # Define min width
    curColumns=$(tput cols)    # get columns of current terminal window
    errorColumnsWidth=""

    clear   # clear the screen

    if (( curLines < minLines )); then # not enough height
        errorLinesHeight=" ${bold}${red}ERROR${normal}\tWindow height ($curLines) is to small (min $minLines)\n"
        errorCount=$((errorCount+1)) # Errorcount +1
    else # enough height available
        if (( curLines > minLines+4 )); then # check if its enough height for ASCII-art as well
            showASCIIArt=true # enable ASCII art
        fi
    fi

    # check columns (width)
    if (( curColumns < minColumns )); then
        errorColumnsWidth=" ${bold}${red}ERROR${normal}\tWindow width ($curColumns) is to small (min $minColumns)\n"
        errorCount=$((errorCount+1)) # Errorcount +1
    fi

    # Show ASCII art only if we have enough space - otherwise skip
    if [ "$showASCIIArt" = true ] ; then
        printf "\n  _)        |               \    _ \ __ __| _)\n"
        printf "   |    \    _|   -_)   _| _ \   __/    |    | \ \ /  -_)\n"
        printf "  _| _| _| \__| \___| _| _/  _\ _|     _|   _|  \_/ \___|\n\n"
    fi

    #print a green line under the header
    printf " %s" "${green}"
    for (( c=1; c<=curColumns-2; c++ )); do
        printf "-"
    done
    printf "%s\n\n" "${normal}"

    # check if errors happened - if so pause the script
    if (( errorCount > 0 )); then
        printf "%s" "$errorLinesHeight"
        printf "%s" "$errorColumnsWidth"
        printf "\n Please resize your terminal window\n\n"
        pause
    fi
}



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# EXECUTECOMMAND
#
# Function:
# - executes the apt commands
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
executeCommand()
{
    printHead

    if [[ $IS_ROOT_USER == false ]]; then # not a root user - check if command needs sudo permissions or not
        # executing as non-root user - lets check if the commands needs sudo permissions or not
        if [[ -z $3  ]]; then # sudo is NOT needed
            printf " Executing command: %s%s%s\n\n" "${bold}" "$2" "${normal}"
            #$1
            CMD="$2"
        else # sudo is needed
            printf " Executing command: %s%s %s%s\n\n" "${bold}" "$3" "$2" "${normal}"
            CMD="sudo $2"
        fi
    else # root user
        printf " Executing command: %s%s%s\n\n" "${bold}" "$2" "${normal}"
        CMD="$2"
    fi
    
    $CMD # execute the command
    
    pause "$1"  # trigger pause and forward the name of the upcoming menu after pause
    
    # unset all variables
    unset "$1"
    unset "$2"
    unset "$3"
}



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CHECK FOR ROOT USER
#
# Function:
# - checks on interaptive start if the script is launched as root user or not
# - needed to check if sudo is needed or not for executing commands in executeCommand()
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function checkForRootUser() 
{
    if [ "$EUID" -ne 0 ]; then # current user != root
        IS_ROOT_USER=false
    else # current user = root
        IS_ROOT_USER=true
    fi
}



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# INIT TEXT AND COLORS
#
# Function:
# - defines some text color and formatting variables
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function initTextAndColors() 
{
    # styles
    normal=$(tput sgr0)                # default
    bold=$(tput bold)                # bold
    #underline=$(tput smul)            # underline
    background='\033[0;100m'        # background

    # colors
    red=$(tput setaf 1)
    green=$(tput setaf 2)
    yellow=$(tput setaf 3)
}



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ON STARTUP
#
# Function:
# - launches all startup relevant functions on application start
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
onStartup()
{
    checkRequirements           # check for required packages
    checkForLinuxDistribution   # check if linuc distri is supported or not
    initTextAndColors           # init color & forating variables
    checkForRootUser            # check if current user is root or not
    displayMainMenu             # load the main menu
}



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Start the nightmare
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
onStartup

