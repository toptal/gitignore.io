/**
 * Module dependencies.
 */
var express = require('express')
  , compression = require('compression')
  , favicon = require('serve-favicon')
  , logger = require('morgan')
  , bodyParser = require('body-parser')
  , methodOverride = require('method-override')
  , errorHandler = require('errorhandler')
  , routes = require('./routes')
  , walk = require('./walk')
  , path = require('path')
  , ua = require("universal-analytics");

require('newrelic');
require('uglify-js-middleware');
require('./walk');  // Build gitignore data

var app = express();
var oneDay = 604800000;
exports.oneDayCache = oneDay;

// all environments
app.set('port', process.env.PORT || 3000);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');
app.use(compression());
app.use(favicon(path.join(__dirname, 'public/gi/img/favicon.ico'), { maxAge: oneDay }));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true}));
app.use(methodOverride());

// development only
if ('development' == app.get('env')) {
  app.use(errorHandler());
}

// Route endpoints
routes(app);

// all environments
app.use(ua.middleware(process.env.GA_TRACKING_ID, {cookieName: '_ga'}));
app.use(express.static(path.join(__dirname, 'public'), { maxAge: oneDay }));
app.use(require('uglify-js-middleware')({ src: path.join(__dirname,'public') }));
app.use(require('less-middleware')(path.join(__dirname,'public'), [], [], [{compress: true}]));

// Start server
app.listen(app.get('port'), function() {
  console.log("Express server listening on port " + app.get('port'));
});
