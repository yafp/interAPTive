[![License](https://img.shields.io/badge/license-GPL3-brightgreen.svg)](LICENSE)


![logo](https://raw.githubusercontent.com/yafp/interAPTive/master/doc/fa-repeat_64_0_000000_none.png) interAPTive
==========

# About
**interAPTive** is an interactive commandline interface for APT (Advanced Packaging Tool on Debian-based Linux distributions).


# Screenshots
![UI](https://raw.githubusercontent.com/yafp/interAPTive/master/doc/current_ui.png)


# Requirements
* apt
* apt-get
* apt-cache

**interAPTive** is focused on **APT**.
APT-GET and APT-CACHE are only used where needed.


# Features
The following commands are supported to far.

**Update**
- apt update
- apt upgrade
- apt dist-upgrade

**Info**
- apt search
- apt show
- apt-cache policy
- apt-get changelog
- apt-cache depends
- apt list --installed
- apt list --upgradable
- apt list --all-versions

**Install**
- apt install
- apt install --reinstall

**Removal**
- apt remove
- apt purge
- apt-get autoremove

**Misc**
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
