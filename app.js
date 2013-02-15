
/**
 * Module dependencies.
 */
require('newrelic')

var express = require('express')
  , routes = require('./routes')
  , http = require('http')
  , https = require('https')
  , fs = require('fs');

var app = express();
var gitIgnores = {};

app.configure(function(){
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.favicon(__dirname + '/public/images/favicon.ico'));
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(require('less-middleware')({ src: __dirname + '/public',compress: true }));
  app.use(express.static(__dirname + '/public'));
  app.use(errorHandler);
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

// Main Page
app.get('/', routes.index);

// API
app.get('/cli', routes.cli);
app.get('/api/list', routes.apiListTypes);
app.get('/api/(:ignore)', routes.apiIgnore);
app.get('/api/*', routes.help);

function errorHandler(err, req, res, next) {
  res.status(500);
  res.render('error', { error: err });
}

http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});

var walk = function(dir, filter, done) {
  var results = [];
  fs.readdir(dir, function(err, list) {
    if (err) return done(err);
    var pending = list.length;
    if (!pending) return done(null, results);
    list.forEach(function(file) {
      file = dir + '/' + file;
      fs.stat(file, function(err, stat) {
        if (stat && stat.isDirectory()) {
          walk(file, filter, function(err, res) {
            results = results.concat(res);
            if (!--pending) done(null, results);
          });
        } else {
          if (file.indexOf(filter) > -1){
            // Strip off file name
            var fileName = file.split("/").pop();
            var name = fileName.split(".")[0];
            var contents = fs.readFileSync(file, 'utf8');
            gitIgnores[name.toLowerCase()] = {
              name: name,
              fileName: fileName,
              contents: contents
            };
          }
          if (!--pending) done(null, results);
        }
      });
    });
  });
};

walk( __dirname + '/data/gitignore', ".gitignore", function(err, results) {
  if (err) throw err;
  var gitIgnoreJSON = []
  for (var key in gitIgnores){
    gitIgnoreJSON.push(gitIgnores[key].name.toLowerCase());
  }
  exports.gitIgnoreJSONObject = gitIgnores;
  exports.gitIgnoreJSONString = gitIgnoreJSON.join(',')+"\n";
});