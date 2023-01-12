// Created by Grigore Stefan <g_stefan@yahoo.com>
// Public domain (Unlicense) <http://unlicense.org>
// SPDX-FileCopyrightText: 2022 Grigore Stefan <g_stefan@yahoo.com>
// SPDX-License-Identifier: Unlicense

messageAction("vendor");

Shell.mkdirRecursivelyIfNotExists("vendor");

if (!Shell.fileExists("vendor/electron-v"+Project.version+"-win32-x64.zip")) {
	var webLink = "https://github.com/electron/electron/releases/download/v"+Project.version+"/electron-v"+Project.version+"-win32-x64.zip";
	var cmd = "curl --insecure --location "+webLink+" --output vendor/electron-v"+Project.version+"-win32-x64.zip";
	Console.writeLn(cmd);
	exitIf(Shell.system(cmd));
};
