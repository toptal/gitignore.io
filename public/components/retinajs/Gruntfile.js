module.exports = function (grunt) {
    'use strict';

    var addBanner = function (content) {
        var banner = grunt.config.get('banner');
        banner = grunt.template.process(banner);
        return banner.concat('\n', content);
    };

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        year: (function () {
            return new Date().getFullYear();
        })(),
        banner: '/*!\n' +
                ' * Retina.js v<%= pkg.version %>\n' +
                ' *\n' +
                ' * Copyright <%= year %> Imulus, LLC\n' +
                ' * Released under the MIT license\n' +
                ' *\n' +
                ' * Retina.js is an open source script that makes it easy to serve\n' +
                ' * high-resolution images to devices with retina displays.\n' +
                ' */\n',

        clean: ['dist'],

        jshint: {
            options: {
                trailing: true,
                jshintrc: '.jshintrc'
            },
            grunt: {
                src: 'Gruntfile.js'
            },
            src: {
                src: 'src/*.js'
            }
        },

        copy: {
            js: {
                src: 'src/retina.js',
                dest: 'dist/retina.js',
                options: {
                    process: addBanner
                }
            }
        },

        uglify: {
            build: {
                options: {
                    banner: '<%= banner %>'
                },
                files: {
                    'dist/retina.min.js': 'dist/retina.js'
                }
            }
        },

        compress: {
            pkg: {
                options: {
                    archive: 'dist/retina-<%= pkg.version %>.zip'
                },
                files: [{
                    src: ['**'],
                    cwd: 'dist/',
                    dest: '/',
                    expand: true
                }]
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.loadNpmTasks('grunt-contrib-compress');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-contrib-uglify');

    grunt.registerTask('default', ['clean', 'jshint', 'copy', 'uglify', 'compress']);
};
