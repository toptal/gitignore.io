
/**
 * Module dependencies.
 */

var express = require('express')
  , routes = require('./routes')
  , http = require('http')
  , https = require('https')
  , fs = require('fs');

var app = express();

app.configure(function(){
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(require('less-middleware')({ src: __dirname + '/public',compress: true }));
  app.use(express.static(__dirname + '/public'));
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

// Main Page
app.get('/', routes.index);

// API
app.get('/api/(:ignore)', routes.api);

http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});

// Set key and certificate for https
var options = {
  key: fs.readFileSync( __dirname + '/data/certs/server-key.pem'),
  cert: fs.readFileSync( __dirname + '/data/certs/server-cert.pem')
};

//https.createServer(options, app).listen(443, function(){
//  console.log("Express server listening on port 443");
//});
