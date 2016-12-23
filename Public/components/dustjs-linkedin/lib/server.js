/*global process*/
var path = require('path'),
    vm = require('vm'),
    dust = require('./dust'),
    parser = require('./parser'),
    compiler = require('./compiler');


// use Node equivalents for some Dust methods
var context = vm.createContext({dust: dust});
dust.loadSource = function(source, path) {
  return vm.runInContext(source, context, path);
};

dust.nextTick = process.nextTick;

module.exports = dust;
