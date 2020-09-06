@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

echo -^> installer electron

if exist installer\ rmdir /Q /S installer
mkdir installer

if exist build\ rmdir /Q /S build
mkdir build

makensis.exe /NOCD "util\electron-installer.nsi"

call grigore-stefan.sign "Electron" "installer\electron-10.1.1-installer.exe"

if exist build\ rmdir /Q /S build
