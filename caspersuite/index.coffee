config = require("../config")
try 
	config_local = require("../config.local")
	for k of config_local
		config[k] = config_local[k]
catch e

provider_config = require("./providers/linkedin").config config
utils = require('utils')
test = require('./testsuite').launch

test casper, provider_config, config, utils