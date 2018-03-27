#!/bin/env bash
 ######################################################
# ProtonVPN CLI Killswitch
# ProtonVPN Command-Line Killswitch Tool
#
# Made with <3 for Linux + MacOS.
###
#Author: Jonas Reindl
######################################################
#""|"-h"|"--help"|"--h"|"-help"|"help")

if [[ "$UID" != 0 ]]; then
    echo "[!]Error: The program requires root access."
    exit 1
fi

function check_requirements() {
    if [[ $(which ufw) == "" ]]; then
        echo "[!]Error: ufw is not installed. Install \`ufw\` package to continue."
        exit 1
    fi
}

function enable_firewall() {
    echo "Enable Killswitch"
    vpn_interface="$1"
    ufw --force reset
    ufw default deny incoming
    ufw default deny outgoing
    ufw allow out on $vpn_interface from any to any
    #only allow connection to api.protonmail.ch
    ufw allow out from any to 185.70.40.185 port 443
    ufw enable
}

function disable_firewall() {
    echo "Disable Killswitch"
    ufw --force reset
    ufw default deny incoming
    ufw default allow outgoing
    ufw enable
}

function help_message() {
    echo "Killswitch Command-Line Tool"
    echo -e "\tUsage:"
    echo "$0 -e, -enable, enable                Enables Killswitch."
    echo "$0 -d, -disable, disable              Disables Killswitch."
    echo "$0 -h, -help, help                    Show this message."
    exit 0
}

check_requirements
if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
user_input="$1"
vpn_interface="tun0"
case $user_input in
    ""|"-h"|"--help"|"--h"|"-help"|"help") help_message
        ;;
    "-e"|"--e"|"-enable"|"--enable"|"enable") enable_firewall $vpn_interface
        ;;
    "-d"|"--d"|"-disable"|"--disable"|"disable") disable_firewall
        ;;
    *)
    echo "[!]Invalid input: $user_input"
    help_message
        ;;
esac
exit 0
fi
