// This file is the one that must be called to launch the testsuite
// It generates a consumer server and launches the client simulation
// through CasperJs in a subprocess

var cp = require('child_process');
var express = require('express');
var fs = require('fs');
var config = require('./config');

try {
	var config_local = require('./config.local');
	for (var k in config_local) {
		config[k] = config_local[k];
	}
} catch (e) {
	// Nothing to do if the config.local.js file doesn't exist
	// However you should override the linkedin account and oauth.io app_key
	// if you haven't done it already
}

// Creates an expressjs app to host the fake consumer server
// That server only returns an HTML page that links to the OAuth.io JavaScript SDK.
var app = express();
app.use(express.static('./public'));
var consumer_server = app.listen(config.port);

// Prepares an argument array for the CasperJS testsuite
var arguments = ['test', './caspersuite/index.coffee'];
var provider_given = false;
if (process.argv)
	for (var k in process.argv) {
		if (k > 1) arguments.push(process.argv[k]);
	}

// Launches the CasperJS test suite in a subprocess
var ps = cp.spawn('casperjs', arguments);
ps.stdout.on('data', function(data) {
	console.log(data.toString().replace("\n", ""));
});
ps.stderr.on('data', function(data) {
	console.log(data.toString().replace("\n", ""));
});
ps.on('exit', function() {
	if (process.argv.indexOf('--keepserver') === -1) consumer_server.close();
});