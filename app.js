
/**
 * Module dependencies.
 */


var express = require('express')
  , subdomain = require('subdomain')
  , routes = require('./routes')
  , http = require('http')
  , path = require('path')
  , fs = require('fs')
  , ua = require("universal-analytics");

require('newrelic');
require('uglify-js-middleware');

var app = express();
var gitIgnores = {};
var oneDay = 604800000;
exports.oneDayCache = oneDay;

// all environments
app.set('port', process.env.PORT || 3000);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');
app.use(subdomain({ base: 'gitignore.io' }))
app.use(express.compress());
app.use(express.favicon(path.join(__dirname, 'public/gi/img/favicon.ico'), { maxAge: oneDay }));
app.use(express.logger('dev'));
app.use(express.json());
app.use(express.urlencoded());
app.use(express.methodOverride());
app.use(app.router);
app.use(ua.middleware(process.env.GA_TRACKING_ID, {cookieName: '_ga'}));
app.use(express.static(path.join(__dirname, 'public'), { maxAge: oneDay }));
app.use(require('uglify-js-middleware')({ src: path.join(__dirname,'public') }));
app.use(require('less-middleware')({ src: path.join(__dirname,'public'),compress: true }));

// development only
if ('development' == app.get('env')) {
  app.use(express.errorHandler());
}

// Main Page
app.get('/', routes.index);
app.get('/dd.json', routes.dropdown);

// API
app.get('/cli', routes.cli);

app.get('/api/list', routes.apiListTypes);
app.get('/api/help', routes.help);
app.get('/api/?', routes.help);
app.get('/api/(:ignore)', routes.apiIgnore);
app.get('/subdomain/(:ignore)', function(req, res) {
  res.redirect('/api/'+req.params.ignore);
});
app.get('/api/f/(:ignore)', routes.apiFile);
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

walk( __dirname + '/data', ".gitignore", function(err, results) {
  if (err) throw err;
  var gitIgnoreJSON = [];
  var dropdownList = [];
  for (var key in gitIgnores){
    gitIgnoreJSON.push(gitIgnores[key].name.toLowerCase());
    dropdownList.push({
      id: gitIgnores[key].name.toLowerCase(),
      text: gitIgnores[key].name
    })
  }
  exports.gitIgnoreDropdownList = dropdownList;
  exports.gitIgnoreJSONObject = gitIgnores;
  exports.gitIgnoreJSONString = gitIgnoreJSON.sort().join(',')+"\n";
  exports.gitIgnoreFileCount = gitIgnoreJSON.length;
});