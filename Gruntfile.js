'use strict';


module.exports = function (grunt) {

    // Load the project's grunt tasks from a directory
    require('grunt-config-dir')(grunt, {
        configDir: require('path').resolve('tasks')
    });

    grunt.loadNpmTasks('grunt-makara-amdify');

  // Register group tasks
  grunt.registerTask('build', ['jshint', 'dustjs', 'makara-amdify', 'less', 'requirejs', 'copyto']);
  grunt.registerTask('test', [ 'jshint', 'mochacli' ]);

};
