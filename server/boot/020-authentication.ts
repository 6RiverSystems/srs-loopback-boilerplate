import {LoopbackApp} from '../IApp';

module.exports = function enableAuthentication(server: LoopbackApp) {
	// enable authentication
	server.enableAuth();
};
