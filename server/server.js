'use strict';

const loopback = require('loopback');
const boot = require('loopback-boot');

const app = module.exports = loopback();

app.start = function(cb) {
	const log = app.logger('Server');

	// start the web server
	return app.listen(function() {
		app.emit('started');
		const baseUrl = app.get('url').replace(/\/$/, '');

		log.info('Web server listening at: %s', baseUrl);
		const explorerConfig = app.get('loopback-component-explorer');

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
