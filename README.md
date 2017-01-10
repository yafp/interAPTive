[![License](https://img.shields.io/badge/license-GPL3-brightgreen.svg)](LICENSE)


![logo](https://raw.githubusercontent.com/yafp/interAPTive/master/img/fa-repeat_32_0_000000_none.png) interAPTive
==========

# About
**interAPTive** is an interactive commandline interface for **APT** (**A**dvanced **P**ackaging **T**ool on Debian-based Linux distributions).


# Userinterface (UI)
## Version 2 (interaptive.sh)
![UI](https://raw.githubusercontent.com/yafp/interAPTive/master/img/current_ui.png)


## Version 1 (interaptive-classic.sh)
![UI](https://raw.githubusercontent.com/yafp/interAPTive/master/img/current_classic_ui.png)

![UI](https://raw.githubusercontent.com/yafp/interAPTive/master/img/interaptive_classic_in_action.gif)



# Requirements
* `apt`
* `whiptail`
* `curl`


# Implemented commands
The following commands are supported

## Maintenance commands
- `apt update`
- `apt upgrade`
- `apt clean`
- `apt autoclean`
- `apt autoremove`
- `apt edit-sources`

## Info commands
- `apt search`
- `apt show`
- `apt policy`
- `apt changelog`
- `apt depends`
- `apt list --installed`
- `apt list --upgradable`
- `apt list --all-versions`

## Install commands
- `apt install`
- `apt install --reinstall`

## Uninstall commands
- `apt remove`
- `apt purge`



# Installation
- Download latest version [here](https://github.com/yafp/interAPTive/archive/master.zip)
- Extract the archive
- Navigate to folder which contains this README.md

Install:
> sudo make install

Uninstall:
> sudo make uninstall


# Launching
You can start **interaptive** by executing the `interaptive` command. An old version aka interaptive-classic can be started via the `interaptive-classic` command.


# Updating
**interAPTive** comes with an selfupdate function which can be triggered from within the script.


# Tested environments
**interAPTive** should work on all Debian-based Linux distributions. It was tested/used in the past on
- Ubuntu 14.04
- Ubuntu 15.10
- Ubuntu 16.04
