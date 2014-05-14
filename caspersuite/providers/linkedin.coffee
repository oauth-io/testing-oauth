exports.config = (top_config) -> 
	return {
		provider_name: "linkedin"
		domain: "www.linkedin.com"
		test_suite_name: "Linkedin test suite"
		form:
			selector: "form.grant-access"
			fields: {
				session_key: top_config.linkedin_account.login,
				session_password: top_config.linkedin_account.password
			}
		auth: {
			validate: (error, response) ->
				return error is null and typeof response?.oauth_token is 'string' and typeof response?.oauth_token_secret is 'string'
		}
	}