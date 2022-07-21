# DevBrew
macOS/Linux/Windows 10 LEMP (NGINX/PHP/JS/MySql) Development Environment via Homebrew(Linuxbrew) using Ansible

[![Build Status](https://travis-ci.org/sergeycherepanov/devbrew.svg?branch=master)](https://travis-ci.org/sergeycherepanov/devbrew)

## Supported applications and frameworks
* Magento 1,2
* Symfony 2,3,4,5,6
* Laravel
* Wordpress
* OroPlatform, OroCRM, OroCommerce
* Akeneo PIM

## Installation on MacOS
1. Install Homebrew
1. Clone the repo: `git clone https://github.com/SergeyCherepanov/devbrew.git ~/devbrew`
1. Run the ansible playbook: `bash ~/devbrew/run.sh --ask-become-pass --tags="php56,php70,php71,php72,php73,php74,php80,mysql80,nodejs,zsh,dnsmasq"` to make full install  
(Wait for finish. Should be without "Fatal" messages)
1. Execute: `brew link php80` (setting default php for cli, you can choose other version (php56 or php74))
1. Add root crt to keychain `sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain $(brew --prefix)/etc/openssl/localCA/cacert.pem`

## Installation on Linux (ElementaryOS/Ubuntu/Debian)
1. Install dependencies: `sudo apt update && sudo apt install -yq curl git patch systemtap-sdt-dev python3 build-essential tar`
1. Install Homebrew
1. Clone the repo: `git clone https://github.com/SergeyCherepanov/devbrew.git ~/devbrew`
1. Run the ansible playbook: `bash ~/devbrew/run.sh --ask-become-pass --tags="php56,php70,php71,php72,php73,php74,php80,mysql80,nodejs,zsh,dnsmasq"` to make full install  
(Wait for finish. Should be without "Fatal" messages)
1. Execute: `brew link php74` (setting default php for cli, you can choose other version (php56, php70, php71, php72, etc))
1. Update your network settings to use 127.0.1.1 as dns server

## Installation on Linux (OpenSUSE 15+)
1. Install dependencies: `sudo zypper install curl git patch systemtap-sdt-devel python3 tar` or `sudo transactional-update pkg install curl git patch systemtap-sdt-devel python3 gcc tar`
1. Open the terminal
1. Execute: `git clone https://github.com/SergeyCherepanov/devbrew.git ~/devbrew`
1. Execute: `bash ~/devbrew/run.sh --ask-become-pass --tags="php56,php70,php71,php72,php73,php74,php80,mysql80,nodejs,zsh,dnsmasq"` to make full install  
   (Wait for finish. Should be without "Fatal" messages)
6. Execute: `brew link php74` (setting default php for cli, you can choose other version (php56, php70, php71, php72, etc))
7. Update your network settings to use 127.0.1.1 as dns server

## Installation on Windows Subsystem for Linux
1. Enable WSL
1. Install Homebrew
1. Install Ubuntu 18.04 from app store
1. Follow steps from  Linux section above
1. Run supervisord by following command: `service supervisord-devbrew start`
1. Update your network settings to use 127.0.1.1 as dns server

## Tags
> You can choose one or all of them, tags don't have conflict
* `zsh` - will install and configure ZSH with PowerLine and Oh-My-Zsh  
* `php56` - will install PHP version 5.6  
* `php70` - will install PHP version 7.0  
* `php71` - will install PHP version 7.1  
* `php72` - will install PHP version 7.2  
* `php73` - will install PHP version 7.3
* `php74` - will install PHP version 7.4  
* `php80` - will install PHP version 8.0
* `php81` - will install PHP version 8.1
* `percona56` - will install Percona Server (mysql) version 5.6
* `percona57` - will install Percona Server (mysql) version 5.7
* `mysql80` - will install Mysql Server 8.0
* `nodejs` - will install NodeJS and NPM  
* `dnsmasq` - will install and configure a dnsmasq service 

## Manage Services

To start/stop/restart services you can use `supctl` (it's supervisorctl wrapper)

## Usage
Put your source code into **www** folder in your home dir in following structure: **~/www/{pool}/{project_name}/**

#### Where:  
{pool} - second level domain name (resolver configured for `dev.com` and `loc.com`, but you can add more hosts directly to `/etc/hosts` file)  
{project} - project name  

If **fqdn** of project should be **wordpress.dev.com**, directory structure must be:

`~/www/dev/wordpress/`

If subfolder **web** or **public** exists, server will use they as web root. For example:    

`~/www/dev/wordpress/web` or  `~/www/dev/wordpress/public`  

### Production domains
Sometimes we are require to use live domains like wordpress.com or google.com  

To do this, just create put source code of your project to `~/www/com/google` and update you `/etc/hosts` file by adding next line: `127.0.0.1 google.com`  

> Keep in mind the local live domains currently not supports ssl

### SSL

The root ca certificate is located in: `%BREW_INSTALL_PATH%/etc/openssl/localCA/cacert.pem`  
Where BREW_INSTALL_PATH by default is /usr/local for macOS and /home/linuxbrew/.linuxbrew for linux.  

## PHP Multi-Version Support

Too force specific version of php just create a flag file in the project root directory, for example:  
`~/www/dev/wordpress/.php56` (php 5.6)  
`~/www/dev/wordpress/.php70` (php 7.0)  
`~/www/dev/wordpress/.php71` (php 7.1)  
`~/www/dev/wordpress/.php72` (php 7.2)  
`~/www/dev/wordpress/.php73` (php 7.3)  
`~/www/dev/wordpress/.php74` (php 7.4)  
`~/www/dev/wordpress/.php80` (php 8.0)  
`~/www/dev/wordpress/.php81` (php 8.1)  

## Mysql

* Mysql (Percona) Server 5.6 binds to 3356 port (user: `root`, password: `root`)  
* Mysql (Percona) Server 5.7 binds to 3306 port (user: `root`, password: `root`)  

## PHP Mail

In ~/mail directory will be drops letter what be sent via php **mail** function
