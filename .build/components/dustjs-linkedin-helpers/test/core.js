(function(exports){

exports.coreSetup = function(suite, auto) {
  auto.forEach(function(test) {
    suite.test(test.name, function(){
      testRender(this, test.source, test.context, test.expected, test.error || {});
    });
  });

  suite.test("base context", function() {
    var base = dust.makeBase({
      sayHello: function() { return "Hello!"; }
    });
    testRender(this, "{sayHello} {foo}", base.push({foo: "bar"}), "Hello! bar");
  });

  suite.test("valid keys", function() {
    testRender(this, "{_foo}{$bar}{baz1}", {_foo: 1, $bar: 2, baz1: 3}, "123");
  });

  suite.test("onLoad callback", function() {
    var unit = this;
    dust.onLoad = function(name, cb) {
      cb(null, "Loaded: " + name);
    };
    dust.render("onLoad", {}, function(err, out) {
      try {
        unit.ifError(err);
        unit.equals(out, "Loaded: onLoad");
      } catch(err) {
        unit.fail(err);
        return;
      }
      unit.pass();
    });
  });

  suite.test("renderSource (callback)", function() {
    var unit = this;
    dust.renderSource('Hello World', {}, function(err, out) {
      try {
        unit.ifError(err);
        unit.equals(out, "Hello World");
      } catch(err) {
        unit.fail(err);
        return;
      }
      unit.pass();
    });
  });

  suite.test("renderSource (stream)", function() {
    var unit = this;
    dust.renderSource('Hello World', {}).on('data', function(data) {
      try {
        unit.equals('Hello World', data);
      } catch(err) {
        unit.fail(err);
        return;
      }
      unit.pass();
    }).on('error', function(err) {
      unit.fail(err);
    });
  });

  suite.test("renderSource (pipe)", function() {
    var unit = this;
    dust.renderSource('Hello World', {}).pipe({
      write: function (data) {
        try {
          unit.equals('Hello World', data);
        } catch(err) {
          unit.fail(err);
          return;
        }
      },
      end: function () {
        unit.pass();
      }
    });
  });

  suite.test("tap (plain text string literal)", function() {
    var unit = this;
    var base_context = { };
    dust.renderSource("plain text. {@tapper value=\"plain text\"/}", base_context, function(err, out) {
      try {
        unit.ifError(err);
        unit.equals(out, "plain text. plain text");
      } catch(err) {
        unit.fail(err);
        return;
      }
      unit.pass();
    });
  });

  suite.test("tap (string literal that includes a string-valued {context variable})", function() {
    var unit = this;
    var base_context = { a:"Alpha" };
    dust.renderSource("a is {a}. {@tapper value=\"a is {a}\"/}", base_context, function(err, out) {
      try {
        unit.ifError(err);
            unit.equals(out, "a is Alpha. a is Alpha");
      } catch(err) {
        unit.fail(err);
        return;
      }
      unit.pass();
    });
  });

  suite.test("tap (reference to string-valued context variable)", function() {
    var unit = this;
    var base_context = { a:"Alpha" };
    dust.renderSource("{a}. {@tapper value=a/}", base_context, function(err, out) {
      try {
        unit.ifError(err);
            unit.equals(out, "Alpha. Alpha");
      } catch(err) {
        unit.fail(err);
        return;
      }
      unit.pass();
    });
  });

  suite.test("tap (string literal that includes a string-valued {context function})", function() {
    var unit = this;
    var base_context = { "b":function() { return "beta"; } };
    dust.renderSource("b is {b}. {@tapper value=\"b is {b}\"/}", base_context, function(err, out) {
      try {
        unit.ifError(err);
            unit.equals(out, "b is beta. b is beta");
      } catch(err) {
        unit.fail(err);
        return;
      }
      unit.pass();
    });
  });

  suite.test("tap (reference to a a string-valued {context function})", function() {
    var unit = this;
    var base_context = { "b":function() { return "beta"; } };
    dust.renderSource("{b}. {@tapper value=b/}", base_context, function(err, out) {
      try {
        unit.ifError(err);
            unit.equals(out, "beta. beta");
      } catch(err) {
        unit.fail(err);
        return;
      }
      unit.pass();
    });
  });

  suite.test("tap (string literal that includes an object-valued {context variable})", function() {
    var unit = this;
    var base_context = { "a":{"foo":"bar"} };
    dust.renderSource("a.foo is {a.foo}. {@tapper value=\"a.foo is {a.foo}\"/}", base_context, function(err, out) {
      try {
        unit.ifError(err);
            unit.equals(out, "a.foo is bar. a.foo is bar");
      } catch(err) {
        unit.fail(err);
        return;
      }
      unit.pass();
    });
  });

  suite.test("tap (reference to an object-valued {context variable})", function() {
    var unit = this;
    var base_context = { "a":{"foo":"bar"} };
    dust.renderSource("{a.foo}. {@tapper value=a.foo/}", base_context, function(err, out) {
      try {
        unit.ifError(err);
            unit.equals(out, "bar. bar");
      } catch(err) {
        unit.fail(err);
        return;
      }
      unit.pass();
    });
  });

  suite.test("tap (string literal that calls a function within an object-valued {context variable})", function() {
    var unit = this;
    var base_context = { "a": {"foo":function() { return "bar"; } } };
    dust.renderSource("a.foo is {a.foo}. {@tapper value=\"a.foo is {a.foo}\"/}", base_context, function(err, out) {
      try {
        unit.ifError(err);
        unit.equals(out, "a.foo is bar. a.foo is bar");
      } catch(err) {
        unit.fail(err);
        return;
      }
      unit.pass();
    });
  });

  suite.test("tap (reference to a function within an object-valued {context variable})", function() {
    var unit = this;
    var base_context = { "a": {"foo":function() { return "bar"; } } };
    dust.renderSource("{a.foo} {@tapper value=a.foo/}", base_context, function(err, out) {
      try {
        unit.ifError(err);
            unit.equals(out, "bar bar");
      } catch(err) {
        unit.fail(err);
        return;
      }
      unit.pass();
    });
  });
};

function testRender(unit, source, context, expected, error) {
  var name = unit.id;
   try {
     dust.loadSource(dust.compile(source, name));
     dust.render(name, context, function(err, output) {
       unit.ifError(err);
       unit.equals(output, expected);
     });
    } catch(err) {
      unit.equals(err.message, error);
    }
    unit.pass();
};

})(typeof exports !== "undefined" ? exports : window);