'use strict';


var DocsModel = require('../../models/docs');


module.exports = function (router) {

    var model = new DocsModel();

    router.get('/', function (req, res) {

        res.render('docs/index', model);

    });

};
