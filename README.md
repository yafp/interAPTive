[![License](https://img.shields.io/badge/license-GPL3-brightgreen.svg)](LICENSE)


![logo](https://raw.githubusercontent.com/yafp/interAPTive/master/img/fa-repeat_64_0_000000_none.png) interAPTive
==========

# About
**interAPTive** is an interactive commandline interface for **APT** (**A**dvanced **P**ackaging **T**ool on Debian-based Linux distributions).


# Userinterface (UI)

![UI](https://raw.githubusercontent.com/yafp/interAPTive/master/img/interaptive_in_action.gif)

![UI](https://raw.githubusercontent.com/yafp/interAPTive/master/img/current_ui.png)


# Requirements
* apt
* apt-get
* apt-cache

**interAPTive** is focused on **apt**.
apt-get and apt-cache are only used where needed.


# Implemented commands
The following commands are supported

## Update commands
- apt update
- apt upgrade
- apt full-upgrade
- apt dist-upgrade

## Info commands
- apt search
- apt show
- apt-cache policy
- apt-get changelog
- apt-cache depends
- apt list --installed
- apt list --upgradable
- apt list --all-versions

## Install commands
- apt install
- apt install --reinstall

## Removal commands
- apt remove
- apt purge
- apt autoremove
- apt-get clean

## Misc
- apt edit-sources


# Installation
- Download latest version [here](https://github.com/yafp/interAPTive/archive/master.zip)
- Extract the archive
- Navigate to folder which contains this README.md

Install by running:
> sudo make install

Uninstall by running:
> sudo make uninstall


# Updating
**interAPTive** comes with an selfupdate function which can be triggered from within the script.


# Tested environments
**interAPTive** should work on all Debian-based Linux distributions. It was tested/used in the past on
- Ubuntu 14.04
- Ubuntu 15.10
- Ubuntu 16.04
