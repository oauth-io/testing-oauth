exports.launch = (casper, provider, config, utils) ->
	casper.test.begin provider.test_suite_name, 5, suite = (test) ->
		casper.start ->
			window.__flag = false
			return

		# Opening the consumer server index page in the headless browser
		if (casper.cli.options.verbose)
			casper.echo 'Opening the index page in the headless browser (http://localhost:' + config.port + ')'
		casper.thenOpen 'http://localhost:' + config.port, ->
			base = this

		# Initializes the OAuth.io SDK
		if (casper.cli.options.verbose)
			casper.echo 'Initializing the OAuth.io Javascript SDK with your app\'s public key'
		casper.then () ->
			initialization = @.evaluate(((config) ->
				window.OAuth.initialize config.app_key
			), config: config)


		# Tries to authenticate a user using OAuth.io redirect feature
		require("./redirect").tests casper, provider, config, utils

		# Actually runs the testsuite
		casper.run()
		return


