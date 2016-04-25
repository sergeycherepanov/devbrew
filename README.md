# dev-env-osx
MAC OS X Dev Environment Php Mysql Nginx via Ansible

1. открыть терминал
2. выполнить: xcode-select —install (это запустит процесс установки XCODE)
3. выполнить: cd /tmp
4. выполнить: git clone git@github.com:SergeyCherepanov/dev-env-osx.git
5. выполнить: dev-env-sox/run.sh (Дождаться завершения. Должно быть без красных надписей и слов Fatal)
6. открыть Системные настройки > LaunchRocket
7. Нажать Scan homebrew и поставить чекбокс  At Login напротив всех необходимых сервисов
8. поставить чекбокс As Root напротив Nginx и Dnsmasq

сайты создать в папке www в домашней папке по принципу:

~/%POOL%/%SITENAME%

где:
pool - это домен первого уровня (dev или loc)
sitename - имя сайта

например если имя домена хотим crm.dev, структура должна быть:

~/dev/crm/

*если внутри будут web или public папки то сервер будет смотреть в них* если их нет, то в корень проекта

в папку ~/mail сбрасываются письма которые отправляет php через функцию mail
