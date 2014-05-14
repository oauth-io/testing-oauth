# This module does the actual redirection / login / permissions validation work

# This is the method called from the testsuite.coffee module
exports.tests = (casper, provider, config, utils) ->
	casper.then ->
		if (casper.cli.options.verbose)
			casper.echo 'Now redirecting to linkedin to log the user in and accept permissions'

		# This evaluates code in the browser to perform the redirection
		redirect = @evaluate ((config, provider)->
			try
				window.OAuth.redirect provider.provider_name, 'http://localhost:' + config.port
			catch e
				return e
			), {
				config: config,
				provider: provider
			}

	# Here we wait for a few seconds to let the page load
	casper.wait 3000, ->


	casper.waitForUrl new RegExp(provider.domain), ->
		form_exists = @evaluate ((selector) ->
			__utils__.exists(selector)
		), {
			selector: provider.form.selector
		}
		# Here we check that the form is loaded and that the selector we
		# have in the config points to something in the page
		@test.assert(form_exists, "Provider authentication form appearance")
		if (casper.cli.options.verbose)
			casper.echo "\nFilling the form with the user credentials and accepting permission"
		@fill provider.form.selector, provider.form.fields, true

	casper.wait 3000, ->

	# This waits for the redirection to the original page
	casper.waitForUrl  new RegExp(config.urlCallback), ->
		# Retrieves the OAuth object values thanks to the OAuth.io callback method.
		authenticate = @evaluate ( ->
			try 
				window.__callbacked = false
				window.__error = undefined
				window.__result = undefined
				window.OAuth.callback((err, result) ->
					window.__callbacked = true
					if (err)
						window.__error = err
					window.__result = result
					window.res = result
				);	
			catch e
				window.__callbacked = true
				window.__error = e
				throw e
			
		)

	# This waits for the callback to have been called
	casper.waitFor (->
		@getGlobal("__callbacked") is true
	), ->
		if (casper.cli.options.verbose)
			casper.echo "Checking that we got a response back and not an error"
		response = @evaluate ->
			return window.__result
		authentication_worked = @evaluate ->
			return (window.__error == undefined or window.__error == null) and typeof window.__result == "object"
		error = @evaluate ->
			return window.__error
		if (casper.cli.options.verbose)
			if error?
				casper.echo "An error occured while getting the OAuth response object"
				utils.dump error
			if response?
				casper.echo "Received post OAuth response object"
				utils.dump response

		# Here we check that we have retrieved what we wanted from the provider (e.g. the access token)
		if (casper.cli.options.verbose)
			casper.echo "Checking that we actually got the fields we wanted in the response"
		@test.assert provider.auth.validate(error, response), 'OAuth token retrieval'
