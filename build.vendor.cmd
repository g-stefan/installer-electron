@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

if not exist vendor\ mkdir vendor

set WEB_LINK=https://github.com/electron/electron/releases/download/v10.1.1/electron-v10.1.1-win32-x64.zip
if not exist vendor\electron-v10.1.1-win32-x64.zip curl --insecure --location %WEB_LINK% --output vendor\electron-v10.1.1-win32-x64.zip
