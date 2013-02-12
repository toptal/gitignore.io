var client = require("../app");
/*
 * GET home page.
 */

exports.index = function(req, res){
  res.render('index', { title: 'Express' });
};

/*
 * GET API page.
 */

exports.apiIgnore = function(req, res){
  console.log(req.params.ignore);
//  var text = app.gitIgnore[req.params.ignore];
//  res.send(text);
};
/*
 * GET List of all ignore types
 */
exports.apiListTypes = function(req, res){
  console.log("here");
  client.redisClient.keys("*", function(err, replies){
    console.log(replies);
    res.send(replies.toString());
  });
};
