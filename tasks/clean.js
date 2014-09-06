'use strict';


module.exports = function clean(grunt) {
	// Load task
	grunt.loadNpmTasks('grunt-contrib-clean');

	// Options
	return {
	    tmp: 'tmp',
	    build: '.build/templates'
	};
};
