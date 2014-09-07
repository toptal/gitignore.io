'use strict';


var DatastoreModel = require('../../models/datastore');

module.exports = function (router) {

    // var model = new DatastoreModel();
    var model = {};
    router.get('/', function (req, res) {

        res.render('datastore/index', model);

    });

};
