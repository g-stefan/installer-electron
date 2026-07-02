// --- set module search paths
var app=require("electron").app;
var path=require("path");
var nodeModulesPath=path.join(path.dirname(app.getPath("exe")),"node_modules");
const Module = require("module");
const nodeModulePathsFn = Module._nodeModulePaths;
Module._nodeModulePaths = (modulePath) => {
	return [nodeModulesPath].concat(nodeModulePathsFn(modulePath));
};
// ---
