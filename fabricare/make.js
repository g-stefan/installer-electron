// Created by Grigore Stefan <g_stefan@yahoo.com>
// Public domain (Unlicense) <http://unlicense.org>
// SPDX-FileCopyrightText: 2022 Grigore Stefan <g_stefan@yahoo.com>
// SPDX-License-Identifier: Unlicense

Fabricare.include("vendor");

// ---

messageAction("make");

if (Shell.fileExists("temp/build.done.flag")) {
	return;
};

Shell.mkdirRecursivelyIfNotExists("output");
Shell.mkdirRecursivelyIfNotExists("temp");

Shell.system("7z x vendor/electron-v"+Project.version+"-win32-x64.zip -aoa -ooutput");

runInPath("temp", function() {
	Shell.system("cmd /C \"call npm install electron-context-menu\"");
});

Shell.rename("temp/node_modules","output/modules");
