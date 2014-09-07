'use strict';


var DatastoreModel = require('../../models/datastore');


module.exports = function (router) {

    router.get('/templates.json', function (req, res) {
        res.setHeader('Cache-Control', 'public, max-age=0');
        res.setHeader('Content-Type', 'text/json');
        res.setHeader('Expires', new Date(Date.now() + 604800000).toUTCString());
        res.send(DatastoreModel.dropdownList);
    });

};
