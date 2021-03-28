@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

call build\build.config.cmd

echo -^> make %PRODUCT_NAME%

if exist output\ rmdir /Q /S output
if exist temp\ rmdir /Q /S temp

mkdir output
mkdir temp

7z x vendor/electron-v%PRODUCT_VERSION%-win32-x64.zip -aoa -ooutput

pushd temp
call npm install electron-context-menu
popd

move "temp\node_modules" "output\modules"

rmdir /Q /S temp
