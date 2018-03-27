*protonvpn-cli*
================

![protonvpn-cli](https://i.imgur.com/tDrwkX5l.png)

# Overview #
protonvpn-cli is a command-line tool for Linux and macOS.

# Requirements #

* `openvpn`
* `python`
* `dialog`
* `wget`
* `sysctl`

The program automatically checks for missing requirements.


# Installation #

```bash
$ git clone "https://github.com/protonvpn/protonvpn-cli"
$ cd protonvpn-cli
$ sudo ./protonvpn-cli.sh -install
```

### Or (one-liner): ###

```bash
$ sudo bash -c "git clone https://github.com/ProtonVPN/protonvpn-cli.git ; ./protonvpn-cli/protonvpn-cli.sh -install"
```

# Usage #


| **Command**                      | **Description**                               |
| :------------------------------- | :-------------------------------------------- |
| `protonvpn-cli -init`            | Initialize ProtonVPN profile on the machine.  |
| `protonvpn-cli -connect`         | Select a VPN from ProtonVPN menu.             |
| `protonvpn-cli -random-connect`  | Connect to a random ProtonVPN VPN.            |
| `protonvpn-cli -fastest-connect` | Connect to a fast ProtonVPN VPN.              |
| `protonvpn-cli -disconnect`      | Disconnect from VPN.                          |
| `protonvpn-cli -ip`              | Print the current public IP address.          |
| `protonvpn-cli -update`          | Update protonvpn-cli.                         |
| `protonvpn-cli -install`         | Install protonvpn-cli.                        |
| `protonvpn-cli -uninstall`       | Uninstall protonvpn-cli.                      |
| `protonvpn-cli -debug -command`  | Run a command in debug mode.                      |
| `protonvpn-cli -help`            | Show help message.                            |


protonvpn-cli can also be used by typing `pvpn`, once installed.


# Compatibility #
* Linux
* macOS
