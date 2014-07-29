/*
 * Route endpoints
 */
var web = require('./web')
  , api = require('./api');

module.exports = function(app) {
  // Web Endpoints
  app.get('/', web.index);
  app.get('/dd.json', web.dropdown);
  app.get('/cli', web.cli);

  // API Endpoints
  app.get('/api/list', api.listTypes);
  app.get('/api/help', api.help);
  app.get('/api/?', api.help);
  app.get('/api/(:ignore)', api.ignore);
  app.get('/api/f/(:ignore)', api.file);
  app.get('/api/*', api.help);
};
