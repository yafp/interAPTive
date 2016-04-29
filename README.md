[![License](https://img.shields.io/badge/license-GPL3-brightgreen.svg)](LICENSE)


![logo](https://raw.githubusercontent.com/yafp/interAPTive/master/doc/fa-repeat_64_0_000000_none.png) interAPTive
==========

# About
**interAPTive** is an interactive commandline interface for **APT** (**A**dvanced **P**ackaging **T**ool on Debian-based Linux distributions).


# Userinterface (UI)
![UI](https://raw.githubusercontent.com/yafp/interAPTive/master/doc/current_ui.png)


# Requirements
* apt
* apt-get
* apt-cache

**interAPTive** is focused on **apt**.
apt-get and apt-cache are only used where needed.


# Features
The following commands are supported

## Update
- apt update
- apt upgrade
- apt dist-upgrade
- apt full-upgrade

## Info
- apt search
- apt show
- apt-cache policy
- apt-get changelog
- apt-cache depends
- apt list --installed
- apt list --upgradable
- apt list --all-versions

## Install
- apt install
- apt install --reinstall

## Removal
- apt remove
- apt purge
- apt-get autoremove

## Misc
- apt edit-sources


# Getting started
- Download latest version [here](https://github.com/yafp/interAPTive/archive/master.zip)
- Extract the archive
- Navigate to folder which contains this README.md

Install by running:
> sudo make install

Uninstall by running:
> sudo make uninstall

**interAPTive** comes with an selfupdate function which can be triggered from within the script.


# Supported environments
interAPTive was tested so far on
- Ubuntu 14.04
- Ubuntu 16.04
