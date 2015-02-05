var uutest    = require('./uutest'),
  helpersTests     = require('./jasmine-test/spec/helpersTests'),
  coreSetup = require('./core').coreSetup,
  dust = require('dustjs-linkedin');

//Add the tapper helper to test the Tap helper.
require("./testUtils");
require('../lib/dust-helpers');

function dumpError(err) {
  var out = err.testName + " -> ";
  if (!err.message) {
    err.message = JSON.stringify(err.expected)
      + " " + err.operator + " " + JSON.stringify(err.actual);
  }
  return out + err.stack;
}

for (var i=0; i<helpersTests.length; i++) {
  var suite = new uutest.Suite({
    pass: function() {
      process.stdout.write("");
    },
    fail: function(err) {
      process.stdout.write("F");
    },
    done: function(passed, failed, elapsed) {
      process.stdout.write("\n");
      console.log(passed + " passed " + failed + " failed " + "(" + elapsed + "ms)");
      this.errors.forEach(function(err) {
        console.log(dumpError(err));
      });
    }
  });

  global.dust = dust;

  coreSetup(suite, helpersTests[i].tests);

  suite.run();
}