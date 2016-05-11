/**
 * Created to abstract logging construction away from other files.
 *
 * This way we can configure remote log storage, etc, here without
 * affecting each file separately.
 *
 * Created by jpollak on 5/11/16.
 */
'use strict';

let extend = require('util')._extend;
let bunyan = require('bunyan');
let Logsene = require('bunyan-logsene');
let LogEntries = require('bunyan-logentries');
let PrettyStream = require('bunyan-prettystream');

let loggingConfig = {
	level: 'debug'
};

let prettyStream = new PrettyStream();
let streams = [
	{stream: prettyStream}
];

prettyStream.pipe(process.stdout);

if (process.env.LOGSENE_TOKEN) {
	streams.push(
		new Logsene({
			token: process.env.LOGSENE_TOKEN
		})
	);
}

// process.env.LOGENTRIES_TOKEN = 'd91a2083-b6cb-4862-9aaf-149acef5e74a';

if (process.env.LOGENTRIES_TOKEN) {
	streams.push(
		{
			level: 'debug',
			stream: LogEntries.createStream({token: process.env.LOGENTRIES_TOKEN}),
			type: 'raw'
		});
}

module.exports = function(name) {

	return bunyan.createLogger(extend(loggingConfig, {
		name: name,
		streams,
		serializers: bunyan.stdSerializers
	}));
};
