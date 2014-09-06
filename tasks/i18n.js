'use strict';


module.exports = function clean(grunt) {
    // Load task
    grunt.registerTask('i18n', [ 'clean', 'localizr', 'dustjs', 'clean:tmp' ]);

    // Options
    return {};
};
