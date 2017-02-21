'use strict';

const gulp = require('gulp');
const ts = require('gulp-typescript');
const sourcemaps = require('gulp-sourcemaps');
const nodemon = require('gulp-nodemon');
const merge = require('merge2');

const tsProject = ts.createProject('tsconfig.json');

gulp.task('default', ['compile']);

gulp.task('compile', function() {
	const tsResult = gulp.src('server/**/*.ts')
		.pipe(sourcemaps.init())
		.pipe(tsProject());

	const resources = gulp.src('resources/**/*');
	const jsSources = gulp.src('server/**/*.js');

	return merge([
		resources,
		jsSources,
		tsResult.js.pipe(sourcemaps.write()),
	]).pipe(gulp.dest('dist'));
});

// gulp.task('compile_test', function() {
// 	let tsResult = gulp.src('test/**/*.ts')
// 	.pipe(sourcemaps.init())
// 	.pipe(tsProject());
//
// 	let resources = gulp.src(['test/**/*', '!test/**/*.js']);
// 	let jsSources = gulp.src('server/**/*.js');
//
// 	return merge([
// 		resources,
// 		jsSources,
// 		tsResult.js.pipe(sourcemaps.write())
// 	]).pipe(gulp.dest('dist-js'));
// });


gulp.task('watch', ['compile'], () => {
	gulp.watch(['server/**/*', 'resources/**/*'], ['compile']);
});

gulp.task('serve', ['watch'], function() {
	return nodemon({
		script: 'dist/server.js',
		ext: 'js json',
		env: {'NODE_ENV': 'development'},
	});
});
