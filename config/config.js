/**
 * Load dependencies
 */
const express = require('express')
, stylus = require('stylus')
, expose = require('express-expose')
, mongoose = require('mongoose')
, nib = require('nib');

/**
 * Exports
 */
module.exports = function(app) {
    // Setup DB Connection
    var dblink = process.env.MONGOHQ_URL || 'mongodb://localhost/votejs';
    const db = mongoose.createConnection(dblink);

    // Compile hack for stylus
    function compile(str, path) {
        return stylus(str).set('filename', path).include(nib.path);
    }

    // Configure express-js
    app.configure(function() {
                      this
                          .use(express.logger('\033[90m:method\033[0m \033[36m:url\033[0m \033[90m:response-time ms\033[0m'))
                          .use(express.cookieParser())
                          .use(express.bodyParser())
                          .use(express.errorHandler({dumpException: true, showStack: true}))
                          .use(express.session({secret: '23jrwpefjp209835u423oirp982U4P28'}));
                  });

    // Add template engine
    app.configure(function() {
                      this
                          .set('views', __dirname + '/../app/views')
                          .set('view engine', 'jade')
                          .use(stylus.middleware({
                                                     src: __dirname + '/../public',
                                                     compile: compile
                                             }))
                          .use(express.static(__dirname + '/../public'));
                  });

    // Save reference to database connection
    app.configure(function() {
                      app.set('db', {
                                  'main': db,
                                  'votes': db.model('Vote'),
                                  'polls': db.model('Poll')
                              });
                      app.set('version', '0.1.2');
                  });

    return app;
};

/*
var config = {};

config.routes = {};

config.mongo = {};
config.mongo.db = 'mongodb://localhost/mydb';

config.server = {};
config.server.port = 1337;
config.server.address = '127.0.0.1';

config.page = {};
config.page.title = 'VoteJS';

module.exports = config;
*/