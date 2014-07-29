/*
 * Application Web Endpoints
 */
var app = require('../app')
  , datastore = require('../datastore');

/*
 * GET home page.
 */
exports.index = function(req, res){
  res.setHeader('Cache-Control', 'public, max-age=' + (app.oneDayCache / 1000));
  res.setHeader('Expires', new Date(Date.now() + app.oneDayCache).toUTCString());
  res.render('index', { title: 'gitignore.io - Create useful .gitignore files for your project', fileCount: app.gitIgnoreFileCount});
};

/*
 * GET dropdown autocomplete JSON.
 */
exports.dropdown = function(req, res){
  res.setHeader('Cache-Control', 'public, max-age=' + (app.oneDayCache / 1000));
  res.setHeader('Expires', new Date(Date.now() + app.oneDayCache).toUTCString());
  res.send(datastore.dropdownList);
};

/*
 * GET Command Line Instructions page.
 */
exports.cli = function(req, res){
  res.setHeader('Cache-Control', 'public, max-age=0');
  res.setHeader('Expires', new Date(Date.now()).toUTCString());
  res.render('cli', { title: 'gitignore.io' });
};
