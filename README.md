# dev-env-osx
MAC OS X Dev Environment Php Mysql Nginx via Ansible

[![Build Status](https://travis-ci.org/SergeyCherepanov/dev-env-osx.svg?branch=master)](https://travis-ci.org/SergeyCherepanov/dev-env-osx)  

## Installation 
1. Open the terminal (just type **terminal** into spotlight)
2. Execute: `xcode-select --install` (it's starts XCODE installation process)
3. Execute: `cd /tmp`
4. Execute: `git clone https://github.com/SergeyCherepanov/dev-env-osx.git`
5. Execute: `bash dev-env-osx/run.sh` (Wait for finish. Should be without "Fatal" messages)
6. Execute: `brew link php70` (setting default php for cli, you can choose other version (php55 or php56))
7. Open **System Preferences** > **LaunchRocket**
8. Press **Scan homebrew** and choose checkbox **At Login** near all you need services
9. Choose checkbox **As Root** for **Nginx** and **Dnsmasq**


## Usage
Add folders with you source code into **www** folder in your home dir: **~/www/{pool}/{project_name}/**

#### Where:  
{pool} - first level domain name (resolver configured for `dev` and `loc`, but you can add more hosts directly to `/etc/hosts` file)  
{project} - project name  

If **fqdn** of project should be **wordpress.dev**, directory structure must be:

`~/www/dev/wordpress/`

If subfolder **web** or **public** exists, server will use they as web root. For example:    

`~/www/dev/wordpress/web` or  `~/www/dev/wordpress/public`  

## PHP Multi-Version Support

There is two ways for using the different php versions for your project

1. Direct call of project via version domain, for example:  
`wordpress.55.dev` (php 5.5),  
`wordpress.56.dev` (php 5.6),  
`wordpress.70.dev` (php 7.0)  

2. Define php version via  empty flag file in project root, for example:   
`~/www/dev/wordpress/.php55` (php 5.5),  
`~/www/dev/wordpress/.php56` (php 5.6),  
`~/www/dev/wordpress/.php70` (php 7.0),  

## PHP Mail

In ~/mail directory will be drops letter what be sent via php **mail** function
