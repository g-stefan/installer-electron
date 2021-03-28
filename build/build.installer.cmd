@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

call build\build.config.cmd

echo -^> installer %PRODUCT_NAME%

if exist installer\ rmdir /Q /S installer
mkdir installer

if exist temp\ rmdir /Q /S temp
mkdir temp

makensis.exe /NOCD "source\electron-installer.nsi"

call grigore-stefan.sign "Electron" "installer\%PRODUCT_BASE%-%PRODUCT_VERSION%-installer.exe"

if exist temp\ rmdir /Q /S temp
