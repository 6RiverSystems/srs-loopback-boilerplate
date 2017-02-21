import Logger = require ('bunyan');

export interface LogFactory {
	(component: string): Logger
}
