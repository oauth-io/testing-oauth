// This is the configuration file for the test suite.
// You can override the values below in another file
// called 'config.local.js' at the root of the project
module.exports = {
	
	// This is the port on which the generated consumer server will
	// be serving the index.html page with oauth-js
    port: 3000,
    
    // This is the oauthd url. You can change it if you are using
    // a private oauthd server
    oauthio_server: 'https://oauth.io',

    // This is the public key of an app on oauth.io that
    // that contains the provider Linkedin, with the keys configured
    // and set to use the 'client-side flow'
    app_key: 'your_app_key_from_oauth_io',
    
	// This is the end-user account that will be used to
	// login to linkedin and accept the permissions selected
	// in the oauth.io key-manager
   	linkedin_account: {
    	login: 'a_linkedin_account_email',
    	password: 'a_linkedin_account_password'
    }
}