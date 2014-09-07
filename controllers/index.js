'use strict';


var IndexModel = require('../models/index');
var DatastoreModel = require('../models/datastore');

module.exports = function (router) {
    router.get('/', function (req, res) {
      var model = new IndexModel();
      model.templateCount = DatastoreModel.fileCount;
      res.render('index', model);
    });
};
