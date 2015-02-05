var jasmine = require('jasmine-node');

//set up describe, it, expect, etc as globals so they can be used in renderTestSpec.js
for(key in jasmine) {
  global[key] = jasmine[key];
}

//require dust, test helpers and helpers
//test to make sure dustjs-linkedin is properly extended
//and require('dustjs-helpers') returns correct object
describe ("Test dustjs-helpers package for node", function() {
  var myDust = require('dustjs-linkedin');
  it("Core dust should not have eq helper by default", function() {
    expect(typeof myDust.helpers.eq).toBe("undefined");
  });
  it ("Helpers should be added to Dust object and should not override existing helpers", function() {
    //add helpers
    var myDustWithTestHelpers = require("../../../test/testUtils"),  //Add the tapper helper to test the Tap helper.
      myDustWithHelpers = require("../../../lib/dust-helpers");

    //myDust variable should have been extended to include helpers
    expect(typeof myDust.helpers.eq).toEqual("function");
    //expect that helpers added before dustjs-helpers require are not overwritten
    expect(typeof myDust.helpers.tapper).toEqual("function");

    //require dustjs-helpers should return full dust object
    expect(myDust).toEqual(myDustWithHelpers);
    expect(myDustWithTestHelpers).toEqual(myDustWithHelpers);
  });
});

//run unit tests defined in test/jasmine-test/spec folder
jasmine.executeSpecsInFolder({
  specFolders : [require('path').dirname(__dirname) + '/spec'],
  isVerbose : true,
  showColors : true,
  onComplete : function(runner, log) {
    if (runner.results().failedCount === 0) {
      return process.exit(0);
    } else {
      return process.exit(1);
    }
  }
});