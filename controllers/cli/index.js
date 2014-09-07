'use strict';


var CliModel = require('../../models/cli');


module.exports = function (router) {

    var model = new CliModel();


    router.get('/', function (req, res) {
        
        res.format({
            json: function () {
                res.json(model);
            },
            html: function () {
                res.render('cli/index', model);
            }
        });
    });

};
