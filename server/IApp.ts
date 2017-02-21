import {Kernel} from 'inversify';
import {LogFactory} from './components/kernel/utils/LogFactory';

export interface Callback {
	(): void;
}

export interface LoopbackApp {
	enableAuth(): void;
	models: any;
	kernel: Kernel;
	logger: LogFactory;
}
