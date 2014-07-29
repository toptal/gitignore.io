var app = require('../app')
  , walk = require('../walk');

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
  res.send(walk.gitIgnoreDropdownList);
}
