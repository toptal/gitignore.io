(function(uutest){

function Test(id, test, timeout, callback) {
  this.id = id;
  this.test = test;
  this.callback = callback;
  this.timeout = timeout;
}

Test.prototype.run = function() {
  var self = this;
  self.timer = setTimeout(function() {
    self.fail(new Error("TimeoutError"));
  }, self.timeout);
  try {
    self.test.call(self);
  } catch(err) {
    self.fail(err);
  }
};

Test.prototype.equals = function(actual, expected, message) {
  if (actual !== expected) {
    var err = new Error();
    if (message) err.message = message;
    throw wrapAssertionError(err, actual, expected, "===");
  }
};

Test.prototype.ifError = function(err) {
  if (err) throw err;
};

Test.prototype.pass = function() {
  clearTimeout(this.timer);
  this.callback();
};

Test.prototype.fail = function(err) {
  clearTimeout(this.timer);
  this.callback(err);
};

uutest.Test = Test;

function Suite(options) {
  this.options = options || {};
  this.timeout = options.timeout || 1000;
  this.tests = [];
}

Suite.prototype.test = function(name, fn) {
  var self = this;
  self.tests.push(new Test(name, fn, self.timeout, function(err) {
    if (err) {
      err.testName = name;
      self.errors.push(err);
      self.emit("fail", err);
    } else {
      self.emit("pass", name);
    }
    self.pending--;
    self.check();
  }));
};

Suite.prototype.run = function() {
  if (this.pending) return;
  var self = this, len = self.tests.length;
  self.errors = [];
  self.emit("start", self.tests);
  self.start = new Date().getTime();
  self.pending = len;
  for (var i=0; i<len; i++) {
    self.tests[i].run();
  }
};

Suite.prototype.check = function() {
  if (this.pending) return;
  var len = this.tests.length,
      passed = len - this.errors.length,
      failed = len - passed;
  this.emit("done", passed, failed, new Date().getTime() - this.start);
};

Suite.prototype.emit = function(type) {
  var event = this.options[type];
  if (event) {
    event.apply(this, Array.prototype.slice.call(arguments, 1));
  }
};

uutest.Suite = Suite;

function wrapAssertionError(err, actual, expected, operator) {
  err.name = "AssertionError";
  err.actual = actual;
  err.expected = expected;
  err.operator = operator;
  return err;
}

})(typeof exports !== 'undefined' ? exports : window.uutest = {});