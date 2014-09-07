'use strict';


var DatastoreModel = require('../../models/datastore');

module.exports = function (router) {

    var model = DatastoreModel.dropdownList;


    router.get('/', function (req, res) {

        res.format({
            json: function () {
                res.json(model);
            },
            html: function () {
                res.render('api/index', model);
            }
        });
    });

};
