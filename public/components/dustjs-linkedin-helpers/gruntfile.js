module.exports = function (grunt) {
  //--------------------------------------------------
  //------------Project config------------------------
  //--------------------------------------------------
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %>\n' +
    '<%= pkg.homepage ? "* " + pkg.homepage + "\\n" : "" %>' +
    '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
    ' Released under the <%= pkg.license %> License */\n',
    distName: '<%=pkg.name%>-<%=pkg.version%>',
    paths: {
      project:          __dirname,
      lib:              '<%=paths.project%>/lib',
      build:            '<%=paths.project%>/tmp',
      helpers:          '<%=paths.build%>/dust-helpers.js',
      helpersMin:       '<%=paths.build%>/dust-helpers.min.js',
      test:             '<%=paths.project%>/test',
      testSpecs:        '<%=paths.test%>/jasmine-test/spec',
      dust:             '<%=paths.project%>/node_modules/dustjs-linkedin/dist/dust-full.min.js',
      dist:             '<%=paths.project%>/dist',
      archive:          '<%=paths.project%>/archive'
    },
    jshint : {
      options: {
        jshintrc: true
      },
      gruntfile: {
        src: 'gruntfile.js'
      },
      libs: {
        src: ['<%=paths.lib%>/**/*.js']
      },
      testSpecs: {
        src: ['<%=paths.testSpecs%>/**/*.js']
      }
    },
    clean : {
      build: ['<%=paths.build%>']
    },
    copy : {
      build : {
        src:  '<%=paths.lib%>/dust-helpers.js',
        dest: '<%=paths.helpers%>',
        options: {
          process: function (content, srcpath) {
            return grunt.template.process('<%= banner %>') + content;
          }
        }
      },
      release : {
        files : [
          {
            src : '<%=paths.helpers%>',
            dest : '<%=paths.dist%>/dust-helpers.js'
          },
          {
            src : '<%=paths.helpersMin%>',
            dest : '<%=paths.dist%>/dust-helpers.min.js'
          },
          {
            src : 'LICENSE',
            dest : '<%=paths.dist%>/LICENSE'
          }
        ]
      }
    },
    uglify: {
      options: {
        banner: '<%= banner %>',
        mangle: {
          except: ['require', 'define', 'module', 'dust']
        }
      },
      build: {
        files : {
          '<%=paths.helpersMin%>' : ['<%=paths.helpers%>']
        }
      }
    },
    jasmine : {
      allTests : {
        src : '<%=paths.helpersMin%>',
        options: {
          keepRunner: false,
          specs:   ['<%=paths.test%>/testUtils.js', '<%=paths.testSpecs%>/renderTestSpec.js'],
          helpers: ['<%=paths.testSpecs%>/helpersTests.js'],
          vendor:  ['<%=paths.dust%>'],
          template: require('grunt-template-jasmine-istanbul'),
          templateOptions: {
            coverage: '<%=paths.build%>/coverage/coverage.json',
            report: '<%=paths.build%>/coverage',
            thresholds: {
              lines: 75,
              statements: 75,
              branches: 75,
              functions: 90
            }
          }
        }
      }
    },
    shell : {
      testNode: {
        command: [
          'node test/server.js',
          'node test/jasmine-test/server/specRunner.js'
        ].join(' && '),
        options: {
          stdout: true,
          failOnError: true
        }
      },
      testRhino : {
        command : function() {
          var commandList = [],
            fs = require('fs');
          fs.readdirSync(__dirname + '/test/rhino-test/lib').forEach( function(rhinoJar) {
            if(rhinoJar.indexOf('.jar') >= 0) {
              commandList.push('java -jar test/rhino-test/lib/' + rhinoJar + ' -f test/rhino-test/rhinoTest.js');
            }
          });
          return commandList.join(' && ');
        },
        options : {
          stdout: true,
          failOnError: true
        }
      },
      gitAddArchive: {
        command: 'git add <%= paths.archive %>',
        options: {
          stdout: true
        }
      }
    },
    compress: {
      distTarBall: {
        options: {
          archive: '<%=paths.archive%>/<%=distName%>.tar.gz',
          mode: 'tgz',
          pretty: true
        },
        files: [
          {
            expand: true,
            cwd: '<%=paths.dist%>',
            src: ['*.js', 'LICENSE'],
            dest: '<%=distName%>/'
          }
        ]
      },
      distZip: {
        options: {
          archive: '<%=paths.archive%>/<%=distName%>.zip',
            mode: 'zip',
            pretty: true
        },
        files: [
          {
            expand: true,
            cwd: '<%=paths.dist%>',
            src: ['*.js', 'LICENSE'],
            dest: '<%=distName%>/'
          }
        ]
      }
    },
    bump: {
      options: {
        files: ['package.json'],
        updateConfigs: ['pkg'],
        push: false,
        commit: true,
        commitFiles: ['-a'],
        createTag: true
      }
    }
  });

  //--------------------------------------------------
  //------------External tasks -----------------------
  //--------------------------------------------------
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-jasmine');
  grunt.loadNpmTasks('grunt-contrib-compress');
  grunt.loadNpmTasks('grunt-bump');
  grunt.loadNpmTasks('grunt-shell');

  //--------------------------------------------------
  //------------Grunt task aliases -------------------
  //--------------------------------------------------
  grunt.registerTask('build',   ['jshint', 'clean:build', 'copy:build', 'uglify:build']);

  //test tasks
  grunt.registerTask('testNode',    ['build', 'shell:testNode']);
  grunt.registerTask('testRhino',   ['build', 'shell:testRhino']);
  grunt.registerTask('testPhantom', ['build', 'jasmine']);
  grunt.registerTask('test',        ['build', 'jasmine', 'shell:testNode', 'shell:testRhino']);

  //release tasks
  grunt.registerTask('buildRelease',    ['test', 'copy:release', 'compress']);
  grunt.registerTask('releasePatch', ['bump-only:patch', 'buildRelease', 'shell:gitAddArchive', 'bump-commit']);
  grunt.registerTask('releaseMinor', ['bump-only:minor', 'buildRelease', 'shell:gitAddArchive', 'bump-commit']);

  //default task - full test
  grunt.registerTask('default', ['test']);
};