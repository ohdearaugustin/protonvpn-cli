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

#silent ufw output
function s_ufw() {
    ufw "$@" > /dev/null
}

function modify_hosts() {
    if [[ "$1" == "backup_hostsconf" ]]; then
        cp "/etc/hosts" "/etc/hosts.protonvpn_backup" #backing-up current hosts
    fi

    if [[ "$1" == "add_api" ]]; then
        echo -e "ProtonVPN API - protonvpn-killswitch\n185.70.40.185\tapi.protonmail.ch" >> "/etc/hosts"
    fi

    if [[ "$1" == "revert_to_backup" ]]; then
        cp "/etc/hosts.protonvpn_backup" "/etc/hosts"
        rm "/etc/hosts.protonvpn_backup"
    fi
}

function enable_firewall() {
    echo "Enable Killswitch"
    modify_hosts backup_hostsconf
    modify_hosts add_api
    vpn_interface="$1"
    s_ufw --force reset
    s_ufw default deny incoming
    s_ufw default deny outgoing
    s_ufw allow out on $vpn_interface from any to any
    ufw enable
}

function disable_firewall() {
    echo "Disable Killswitch"
    s_ufw --force reset
    s_ufw default deny incoming
    s_ufw default allow outgoing
    ufw enable
    modify_hosts revert_to_backup
}

function modify_firewall() {
    method=$1
    ip=$2
    proto=$3

    if [[ $method == "open" ]]; then
        if [[ $proto == "udp" ]]; then
            s_ufw allow out from any to $ip port 1194 proto udp
        fi

        if [[ $proto == "tcp" ]]; then
            s_ufw allow out from any to $ip port 443 proto tcp
        fi
    fi

    if [[ $method == "close" ]]; then
        if [[ $proto == "udp" ]]; then
            s_ufw deny out from any to $ip port 1194 proto udp
        fi

        if [[ $proto == "tcp" ]]; then
            s_ufw deny out from any to $ip port 443 proto tcp
        fi
    fi
}

function firewall_api() {
    api_ip="185.70.40.185"
    method=$1
    if [[ $method == "open" ]]; then
        modify_firewall open $api_ip tcp
    fi

    if [[ $method == "close" ]]; then
        modify_firewall close $api_ip tcp
    fi
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
