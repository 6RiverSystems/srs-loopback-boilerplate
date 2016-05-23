'use strict';

let loopback = require('loopback');
let boot = require('loopback-boot');

let app = module.exports = loopback();

app.start = function(cb) {
	let log = app.logger('Server');

	// start the web server
	return app.listen(function() {
		app.emit('started');
		let baseUrl = app.get('url').replace(/\/$/, '');

		log.info('Web server listening at: %s', baseUrl);
		let explorerConfig = app.get('loopback-component-explorer');

		if (explorerConfig && explorerConfig.mountPath) {
			log.info('Browse your REST API at %s%s', baseUrl, explorerConfig.mountPath);
		}

		cb && cb();
	});
};

// Bootstrap the application, configure models, datasources and middleware.
// Sub-apps like REST API are mounted via boot scripts.
boot(app, __dirname, function(err) {
	if (err) {
		throw err;
	}

	// start the server if `$ node server.js`
	if (require.main === module) {
		app.start();
	}

});
