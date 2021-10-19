# DevBrew
macOS/Linux/Windows 10 LEMP (NGINX/PHP/JS/MySql) Development Environment via Homebrew(Linuxbrew) using Ansible

[![Build Status](https://travis-ci.org/sergeycherepanov/devbrew.svg?branch=master)](https://travis-ci.org/sergeycherepanov/devbrew)

## Supported applications and frameworks
* Magento Commerce, Magento Commerce 2
* Symfony 2,3,4
* Laravel
* Wordpress
* OroPlatform, OroCRM, OroCommerce
* Akeneo PIM

## Modules which will be enabled by default for all versions of php (5.6, 7.0, 7.1, 7.2)
`apcu`, `bcmath`, `calendar`, `Core`, `ctype`, `curl`, `date`, `dba`, `dom`, `exif`, `fileinfo`, `filter`, `ftp`, `gd`, `gettext`, `hash`, `iconv`, `igbinary`, `intl`, `json`, `ldap`, `libxml`, `mbstring`, `mcrypt`, `mysqli`, `mysqlnd`, `odbc`, `openssl`, `pcntl`, `pcre`, `PDO`, `pdo_mysql`, `PDO_ODBC`, `pdo_pgsql`, `pdo_sqlite`, `Phar`, `posix`, `readline`, `redis`, `Reflection`, `session`, `shmop`, `SimpleXML`, `soap`, `sockets`, `sodium`, `SPL`, `sqlite3`, `standard`, `sysvmsg`, `sysvsem`, `sysvshm`, `tideways_xhprof`, `tidy`, `tokenizer`, `wddx`, `xml`, `xmlreader`, `xmlrpc`, `xmlwriter`, `Zend OPcache`, `zip`, `zlib`

## Installation on MacOS
1. Open the terminal (just type **terminal** into spotlight)
1. Install cli tools: `xcode-select --install` (it's starts XCODE installation process)
1. Execute: `git clone https://github.com/SergeyCherepanov/devbrew.git ~/devbrew`
1. Execute: `bash ~/devbrew/run.sh --ask-become-pass --tags="php56,php70,php71,php72,php73,php74,php80,mysql80,nodejs,zsh,dnsmasq"` to make full install  
(Wait for finish. Should be without "Fatal" messages)
1. Execute: `brew link php80` (setting default php for cli, you can choose other version (php56 or php74))
1. Add root crt to keychain `sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain /usr/local/etc/openssl/localCA/cacert.pem`

## Installation on Linux (ElementaryOS/Ubuntu/Debian)
1. Open the terminal
1. Install dependencies: `sudo apt update && sudo apt install -yq curl git`
1. Execute: `git clone https://github.com/SergeyCherepanov/devbrew.git ~/devbrew`
1. Execute: `bash ~/devbrew/run.sh --ask-become-pass --tags="php56,php70,php71,php72,php73,php74,php80,mysql80,nodejs,zsh,dnsmasq"` to make full install  
(Wait for finish. Should be without "Fatal" messages)
1. Execute: `brew link php74` (setting default php for cli, you can choose other version (php56, php70, php71 or php72))

## Installation on Windows Subsystem for Linux
1. Enable WSL
2. Install Ubuntu 18.04 from app store
3. Follow steps from  Linux section above
4. Run supervisord by following command: `service supervisord-devbrew start`
5. Update your network settings to use 127.0.1.1 as dns server

## Tags
> You can choose one or all of them, tags don't have conflict
* `zsh` - will install and configure ZSH with PowerLine and Oh-My-Zsh  
* `php56` - will install PHP version 5.6  
* `php70` - will install PHP version 7.0  
* `php71` - will install PHP version 7.1  
* `php72` - will install PHP version 7.2  
* `php73` - will install PHP version 7.3
* `php74` - will install PHP version 7.4  
* `php74` - will install PHP version 8.0
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

## Mysql

* Mysql (Percona) Server 5.6 binds to 3356 port (user: `root`, password: `root`)  
* Mysql (Percona) Server 5.7 binds to 3306 port (user: `root`, password: `root`)  

## PHP Mail

In ~/mail directory will be drops letter what be sent via php **mail** function

## Know Issues (macOS)

### Error: /usr/local is not writable.

> If you reach "Error: /usr/local is not writable.", you need to disable the "System Integrity Protection".  

To enable or disable System Integrity Protection, you must boot to Recovery OS and run the csrutil(1) command from the Terminal.  

Boot to Recovery OS by restarting your machine and holding down the Command and R keys at startup.  
Launch Terminal from the Utilities menu.  
Enter the following command: `$ csrutil disable`  

After enabling or disabling System Integrity Protection on a machine, a reboot is required.  

### Configure: error: Cannot find libz"
This error happens sometime on Mojave, just reinstall headers:
```
sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /
```
