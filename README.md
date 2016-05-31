# dev-env-osx
MAC OS X Dev Environment Php Mysql Nginx via Ansible

1. Open the terminal (just type **terminal** into spotlight)
2. execute: xcode-select —install (it's starts XCODE installation process)
3. execute: cd /tmp
4. execute: git clone git@github.com:SergeyCherepanov/dev-env-osx.git
5. execute: dev-env-osx/run.sh (Wit to finish. Should be without "Fatal" messages)
6. open **System Preferences** > **LaunchRocket**
7. Press Scan homebrew and choose checkbox **At Login** near all you need services
8. Choose checkbox **As Root** for **Nginx** and **Dnsmasq**

put folders with you web projects into **www** folder in your home dir:

**~/www/{pool}/{sitename}/**  
where:  
pool - first level domain name (dev или loc)  
sitename - project name  

For example if **fqdn** of project should be **crm.dev**, directory structure must be:

~/www/dev/crm/

if subfolders **web** or **public** exists,server will use they as web root

in ~/mail directory will be drops letter what be sent via php **mail** function
