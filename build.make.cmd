@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

echo -^> make electron

call build.config.cmd

if exist release\ rmdir /Q /S release
if exist build\ rmdir /Q /S build

mkdir release
mkdir build

7z x vendor/electron-v%PRODUCT_VERSION%-win32-x64.zip -aoa -orelease

pushd build
call npm install electron-context-menu
popd

move "build\node_modules" "release\modules"

rmdir /Q /S build
