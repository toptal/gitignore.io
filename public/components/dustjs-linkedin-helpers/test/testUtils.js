(function(dust) {
  //Add the tapper helper to test the Tap helper.
  dust.helpers.tapper = function(chunk, context, bodies, params) {
    var result = dust.helpers.tap(params.value,chunk,context);
    chunk.write(result);
    return chunk;
  };

  if(typeof exports !== 'undefined'){
    module.exports = dust;
  }
})(typeof exports !== 'undefined' ? require('dustjs-linkedin') : dust);