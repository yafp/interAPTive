![logo](https://raw.githubusercontent.com/yafp/interAPTive/master/img/fa-repeat_32_0_000000_none.png) interAPTive Changelog
==========

2.x - Whiptail it (until now)
============================
- Moved UI to whiptail for most cases
- Old 1.x version is now renamed to interaptive-classic
- Disabled selfupdate in interaptive-classic (#33)
- Replaced apt-get and apt-cache commands with apt



1.0 - Works for me (20161216)
=============================
- Finish him ;)



0.7 - Less might be more (201606xx)
===================================
- Added man-page tags to 'Info' function
- Output and dialogs should now use similar colors / styles now
- MinLines +1 = 35
- Improving output of startup checks
- Removed checkForApt function
- Shrinking main UI via moving extra commands to insert prompt line (minLines = 30)
- Log function is using 'less' if it displays '[A]ll' events (#27)
- Added distribution check on start (#28)
- Fixing a bug in the selfupdate function (#29)
- Adding random developer quotes on app exit (#30)
- Removed several script style errors using 'shellcheck' (#31)



0.6 - Rust (20160503)
=====================
- Change min window height handling (#20)
- Add apt full-upgrade command (#22)
- Add apt-get clean command (#23)
- Write errors to syslog via logger (#25)
- Optimize selfupdate (#26)
- Invalid command input by user now throws an error message



0.5 - sup? (20160425)
=====================
- Optimized window-size check (ASCII-art might get hidden if that helps) (#16)
- Add Help command (#17)
- Add selfupdate function (#18)
- Migrate apt list command (#19)



0.4 - aptsh? (20160419)
=======================
- Restructured command-list & related command-numbers
- Add Clear screen while on exit
- Add command apt-cache depends (#12)
- Add command apt-get changelog (#13)
- Add command apt install --reinstall (#14)
- Add window-size check (#15)



0.3 - Some more (20160418)
==========================
- Optimize command-list formatting (#7)
- Add command apt purge (#8)
- Fix bug in pause function (#9)
- Add apt history function (#10)



0.2 - More more more (20160416)
===============================
- Check if apt is available (#1)
- Terminal width is now recalculated on each header print (#2)
- Add command apt list (#3)
- Add command apt edit-sources (#4)
- Adding a changelog (#6)



0.1 - The initial one (20160416)
================================
- Initial version (#5)
