/*global describe:false, it:false, beforeEach:false, afterEach:false*/

'use strict';


var kraken = require('kraken-js'),
    express = require('express'),
    request = require('supertest');


describe('/api', function () {

    var app, mock;


    beforeEach(function (done) {
        app = express();
        app.on('start', done);
        app.use(kraken({
            basedir: process.cwd()
        }));

        mock = app.listen(1337);

    });


    afterEach(function (done) {
        mock.close(done);
    });


    it('should say "gitignore.io help"', function (done) {
        request(mock)
            .get('/api')
            .expect(200)
            .expect('Content-Type', /html/)
            .expect(/gitignore.io help/)
            .end(function (err, res) {
                done(err);
            });
    });

});
