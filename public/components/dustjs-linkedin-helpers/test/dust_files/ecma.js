if (!Array.prototype.forEach) {
  Array.prototype.forEach = function(fun /*, thisp */) {
    "use strict";

    if (this === void 0 || this === null)
      throw new TypeError();

    var t = Object(this);
    var len = t.length >>> 0;
    if (typeof fun !== "function")
      throw new TypeError();

    var thisp = arguments[1];
    for (var i = 0; i < len; i++) {
      if (i in t)
        fun.call(thisp, t[i], i, t);
    }
  };
}

if (!Array.prototype.map) {
  Array.prototype.map = function(fun /*, thisp */) {
    "use strict";

    if (this === void 0 || this === null)
      throw new TypeError();

    var t = Object(this);
    var len = t.length >>> 0;
    if (typeof fun !== "function")
      throw new TypeError();

    var res = new Array(len);
    var thisp = arguments[1];
    for (var i = 0; i < len; i++) {
      if (i in t)
        res[i] = fun.call(thisp, t[i], i, t);
    }

    return res;
  };
}

if (!String.prototype.trim) {
  String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g,"");
  }
}

if (!String.prototype.trimLeft) {
  String.prototype.trimLeft = function() {
    return this.replace(/^\s+/,"");
  }
}

if (!String.prototype.trimRight) {
  String.prototype.trimRight = function() {
    return this.replace(/\s+$/,"");
  }
}