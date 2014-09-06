'use strict';


module.exports = function localizr(grunt) {
	// Load task
	grunt.loadNpmTasks('grunt-localizr');

	// Options
	return {
	    files: ['public/templates/**/*.dust'],
        options: {
            contentPath: ['locales/**/*.properties']
        }
	};
};