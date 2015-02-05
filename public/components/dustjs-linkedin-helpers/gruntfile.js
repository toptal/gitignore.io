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
      dust:             '<%=paths.project%>/node_modules/dustjs-linkedin/dist/dust-full.js',
      dustMin:          '<%=paths.project%>/node_modules/dustjs-linkedin/dist/dust-full.min.js',
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
      /*tests production (minified) code*/
      testProd : {
        src : '<%=paths.helpersMin%>',
        options: {
          keepRunner: false,
          specs:   ['<%=paths.test%>/testUtils.js', '<%=paths.testSpecs%>/renderTestSpec.js'],
          helpers: ['<%=paths.testSpecs%>/helpersTests.js'],
          vendor:  ['<%=paths.dustMin%>']
        }
      },
      /*tests unminified code, mostly used for debugging by `grunt dev` task*/
      testDev : {
        src: '<%=paths.helpers%>',
        options : {
          keepRunner: false,
          specs :   '<%=jasmine.testProd.options.specs%>',
          helpers : '<%=jasmine.testProd.options.helpers%>',
          vendor :  ['<%=paths.dust%>']
        }
      },
      /* Used for coverage report only based on unminified code.
         Not suited for debugging because istanbul decorates and jumbles code*/
      coverage : {
        src: '<%=paths.helpers%>',
        options : {
          keepRunner: false,
          specs :   '<%=jasmine.testProd.options.specs%>',
          helpers : '<%=jasmine.testProd.options.helpers%>',
          vendor :  '<%=jasmine.testProd.options.vendor%>',
          template: require('grunt-template-jasmine-istanbul'),
          templateOptions: {
            coverage: '<%=paths.build%>/coverage/coverage.json',
            report: '<%=paths.build%>/coverage',
            thresholds: {
              lines: 90,
              statements: 90,
              branches: 80,
              functions: 80
            }
          }
        }
      }
    },
    connect: {
      testServer: {
        options: {
          port: 3000,
          keepalive: false
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
    },
    log : {
      testClient: {
        message: 'Navigate to http://localhost:<%= connect.testServer.options.port %>/_SpecRunner.html\nCtrl-C to kill the server.'
      },
      coverage: {
        message: 'Open <%=jasmine.coverage.options.templateOptions.report%>/index.html in the browser to view the coverage.'
      }
    },
    watch: {
      lib: {
        files: ['<%=paths.lib%>/**/*.js'],
        tasks: ['clean:build', 'buildLib']
      },
      gruntfile: {
        files: '<%= jshint.gruntfile.src %>',
        tasks: ['jshint:gruntfile']
      },
      lib_test: {
        files: ['<%=paths.lib%>/**/*.js', '<%=paths.testSpecs%>/**/*.js'],
        tasks: ['testPhantom']
      }
    }
  });

  //--------------------------------------------------
  //------------Custom tasks -------------------------
  //--------------------------------------------------
  grunt.registerMultiTask('log', 'Print messages defined via config', function() {
    grunt.log.ok(this.data.message);
  });

  //--------------------------------------------------
  //------------External tasks -----------------------
  //--------------------------------------------------
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-jasmine');
  grunt.loadNpmTasks('grunt-contrib-connect');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-compress');
  grunt.loadNpmTasks('grunt-bump');
  grunt.loadNpmTasks('grunt-shell');

  //--------------------------------------------------
  //------------Grunt task aliases -------------------
  //--------------------------------------------------
  grunt.registerTask('buildLib',     ['jshint:libs', 'copy:build']);
  grunt.registerTask('build',        ['clean:build', 'jshint:testSpecs', 'buildLib', 'uglify:build']);

  //test tasks
  grunt.registerTask('testNode',     ['build', 'shell:testNode']);
  grunt.registerTask('testRhino',    ['build', 'shell:testRhino']);
  grunt.registerTask('testPhantom',  ['build', 'jasmine:testProd']);
  grunt.registerTask('test',         ['build', 'jasmine:testProd', 'shell:testNode', 'shell:testRhino', 'jasmine:coverage']);

  //task for debugging in browser
  grunt.registerTask('dev',          ['build', 'jasmine:testDev:build', 'connect:testServer','log:testClient', 'watch:lib']);

  //task to run unit tests on client against prod version of code
  grunt.registerTask('testClient',   ['build', 'jasmine:testProd:build', 'connect:testServer', 'log:testClient', 'watch:lib_test']);

  //coverage report
  grunt.registerTask('coverage',     ['jasmine:coverage', 'log:coverage']);

  //release tasks
  grunt.registerTask('buildRelease', ['test', 'copy:release', 'compress']);
  grunt.registerTask('releasePatch', ['bump-only:patch', 'buildRelease', 'shell:gitAddArchive', 'bump-commit']);
  grunt.registerTask('releaseMinor', ['bump-only:minor', 'buildRelease', 'shell:gitAddArchive', 'bump-commit']);

  //default task - full test
  grunt.registerTask('default',      ['test']);
};
