Testing OAuth with CasperJs
===========================

This project is a proof of concept that uses [OAuth.io](https://oauth.io) and [CasperJs](http://casperjs.org/) to test the OAuth flow of Linkedin functionnaly, from the end-user point of vue.

Dependencies
------------

For the project to work, you need to install [PhantomJs](http://phantomjs.org) and [CasperJs](http://casperjs.org). 

**PhantomJs**

To install PhantomJs, just get the binary from the [PhantomJs download page](http://phantomjs.org/download.html), and link it as `phantomjs` in your PATH.

**CasperJs**

To install [CasperJs](http://docs.casperjs.org/en/latest/installation.html#installing-from-npm), just run the following command in your console (note that CasperJs is available through npm, but is not a Nodejs module).

```sh
$ npm install -g casperjs
```

**Other dependencies**

Before running the testsuite don't forget to run :

```sh
$ npm install
```

Configuration
-------------

To be able to use the testsuite, you must first configure everything. The default configuration is available in the `config.js` file. You can override the fields in that file by creating a `config.local.js` file, copying the default values and changing them.

**OAuth.io public app key**

The first field you must configure is the public key of the OAuth.io app you are going to use to test the OAuth flow.

This app must be configured in your [key-manager](https://oauth.io/key-manager)to contain the provider Linkedin, with the right keys and set to use the `client-side flow`.

Once that is done, you can copy the app's public key in your `config.local.js`file :

```javascript
module.exports = {
    ...
    app_key: 'your_app_key',
    ...
};
```

**Linkedin account credentials**

Then you need to add your linkedin credentials (or those of a test account) in your `config.local.js` :

```javascript
module.exports = {
    ...
    linkedin_account: {
        login: 'the_account_email',
        password: 'the_account_password'
    },
    ...
};
```


Launching the test suite
------------------------

Once everything's configured, all you have to do is to launch the testsuite by running the following command in the project's folder :

```sh
$ node index.js
```

Don't worry if it waits for several seconds, it needs to load pages and that can take some time.

If everything worked, you should see that in the consolegi :

```sh
Test file: ./caspersuite/index.coffee                                           
# Linkedin test suite
PASS Provider authentication form appearance
PASS OAuth token retrieval
```

You can pass the `--verbose` argument to get more info about what's going on :

```sh
$ node index.js --verbose
```


License
-------

This example project is licensed under the Apache2 license.
