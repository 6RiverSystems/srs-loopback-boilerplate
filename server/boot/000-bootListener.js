'use strict';

module.exports = function(app) {

	app.on('booted', () => {

		const log = app.logger('Server');

		log.debug('booted');
		app.isBooted = true;
	});

};
