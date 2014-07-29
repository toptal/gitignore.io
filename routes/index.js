/*
 * Route endpoints
 */
var root = require('./root')
  , api = require('./api');

module.exports = function(app) {
  // Main Page
  app.get('/', root.index);
  app.get('/dd.json', root.dropdown);

  // API
  app.get('/cli', api.cli);

  app.get('/api/list', api.listTypes);
  app.get('/api/help', api.help);
  app.get('/api/?', api.help);
  app.get('/api/(:ignore)', api.ignore);
  app.get('/api/f/(:ignore)', api.file);
  app.get('/api/*', api.help);
};
