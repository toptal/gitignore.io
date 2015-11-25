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

    it('should give comma-separated list', function (done) {
        request(mock)
            .get('/api/list')
            .expect(200)
            .expect('Content-Type', /text\/plain/)
            .expect(/^([^,]+,)+[^,]+\n?$/)
            .end(function (err, res) {
                done(err);
            });
    });

    it('should give newline-separated list', function (done) {
        request(mock)
            .get('/api/list?format=lines')
            .expect(200)
            .expect('Content-Type', /text\/plain/)
            .expect(/^([^\n]+\n)+[^\n]+\n?$/)
            .end(function (err, res) {
                done(err);
            });
    });

    it('should give json list', function (done) {
        request(mock)
            .get('/api/list?format=json')
            .expect(200)
            .expect('Content-Type', /application\/json/)
            .end(function (err, res) {
                done(err);
            });
    });

});
