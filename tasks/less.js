'use strict';


module.exports = function less(grunt) {
	// Load task
	grunt.loadNpmTasks('grunt-contrib-less');

	// Options
	return {
	    build: {
            options: {
                cleancss: false
            },
            build: {
                files: [{
                    expand: true,
                    cwd: 'public/css',
                    src: ['**/*.less'],
                    dest: '.build/css/',
                    ext: '.css'
                }]
            }
	    }
	};
};
