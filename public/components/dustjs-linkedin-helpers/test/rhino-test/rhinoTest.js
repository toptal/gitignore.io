var setTimeout,
  clearTimeout,
  setInterval,
  clearInterval;

//set up functions missing in Rhino
(function () {
  var timer = new java.util.Timer();
  var counter = 1,
    ids = {};

  setTimeout = function (fn, delay) {
    var id = counter++;
    ids[id] = new JavaAdapter(java.util.TimerTask,{run: fn});
    timer.schedule(ids[id], delay);
    return id;
  }

  clearTimeout = function (id) {
    ids[id].cancel();
    timer.purge();
    delete ids[id];
  }

  setInterval = function (fn,delay) {
    var id = counter++;
    ids[id] = new JavaAdapter(java.util.TimerTask,{run: fn});
    timer.schedule(ids[id],delay,delay);
    return id;
  }

  clearInterval = clearTimeout;
})();

print('Running unit tests with ' + environment['java.class.path']);

var requiredFiles = [
    'node_modules/grunt-contrib-jasmine/vendor/jasmine-1.3.1/jasmine.js',
    'node_modules/dustjs-linkedin/dist/dust-full.min.js',
    'tmp/dust-helpers.min.js',
    'test/testUtils.js',
    'test/jasmine-test/spec/helpersTests.js',
    'test/jasmine-test/spec/renderTestSpec.js'
  ];

//load all of the dependencies and unit tests
for(var i = 0; i < requiredFiles.length; i++){
  load(requiredFiles[i]);
}
var jasmineEnv = jasmine.getEnv(),
  reporter = new jasmine.Reporter();

jasmineEnv.addReporter(reporter);

reporter.reportSpecResults = function(spec){
  java.lang.System.out.print('.');
}

//set up reporter to print results to console and quit rhino shell
reporter.reportSuiteResults = function (suite) {
  print('\n');
  var passed = 0, failed = [];
  for(var i = 0; i < suite.specs_.length; i ++) {
    if(suite.specs_[i].results_.failedCount > 0) {
      print('\tFailed: ' + suite.specs_[i].description);
      failed.push(suite.specs_[i]);
    } else {
      //print('\tPassed: ' + suite.specs_[i].description);
      passed++;
    }
  }
  print('Passed ' + passed + ' Failed ' + failed.length + '\n');

  if(failed.length > 0) {
    java.lang.System.exit(1);
  } else {
    java.lang.System.exit(0);
  }
};

//execute unit tests
jasmineEnv.execute();