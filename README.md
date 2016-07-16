# dev-env-osx
MAC OS X Dev Environment Php Mysql Nginx via Ansible

1. Open the terminal (just type **terminal** into spotlight)
2. Execute: xcode-select —install (it's starts XCODE installation process)
3. Execute: cd /tmp
4. Execute: git clone git@github.com:SergeyCherepanov/dev-env-osx.git
5. Execute: dev-env-osx/run.sh (Wait for finish. Should be without "Fatal" messages)
6. Open **System Preferences** > **LaunchRocket**
7. Press **Scan homebrew** and choose checkbox **At Login** near all you need services
8. Choose checkbox **As Root** for **Nginx** and **Dnsmasq**

put folders with you web projects into **www** folder in your home dir:



**~/www/{pool}{version_suffix}/{project_name}/**
where:  
pool - first level domain name with php version suffix (dev55, dev56, dev70 or loc55, loc56, loc70)
sitename - project name  

For example if **fqdn** of project should be **crm.dev70**, directory structure must be:

~/www/dev70/crm/

if subfolders **web** or **public** exists,server will use they as web root

in ~/mail directory will be drops letter what be sent via php **mail** function
