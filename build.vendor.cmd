@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

echo -^> vendor electron

call build.config.cmd

if not exist vendor\ mkdir vendor

set WEB_LINK=https://github.com/electron/electron/releases/download/v%PRODUCT_VERSION%/electron-v%PRODUCT_VERSION%-win32-x64.zip
if not exist vendor\electron-v%PRODUCT_VERSION%-win32-x64.zip curl --insecure --location %WEB_LINK% --output vendor\electron-v%PRODUCT_VERSION%-win32-x64.zip
