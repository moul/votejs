/**
 * Load dependencies
 */
const Server = {}
, express = require('express')
//, stylus = require('stylus')
, mongoose = require('mongoose')
//, nib = require('nib')

, models = require('./models')
, config = require('./config')
, routes = require('./routes')
, environments = require('./environments')
, errors = require('./errors')
, hooks = require('./hooks')
;

/**
 * Exports
 */
module.exports = function() {
    Server.root = __dirname;

    const app = express.createServer();
    models(app);
    config(app);
    environments(app);
    routes(app);
    errors(app);
    hooks(app);
    return app;
};

/*
//,_ = require('./lib/underscore/underscore')
//, path = require('path')
//, sys = require('sys')

Server.root = __dirname,
global.Server = Server,
global.app = express.createServer();

Server.setup = require('./lib/setup.js').setup({
                                                   app: app,
                                                   mongoose: require('mongoose'),
                                                   io: require('socket.io'),
                                                   express: express,
                                                   config: config,
                                                   paths: {
                                                       views: path.join(Server.root, 'app', 'views'),
                                                       controllers: path.join(Server.root, 'app', 'controllers'),
                                                       root: path.join(Server.root, 'public'),
                                                       models: path.join(Server.root, 'app', 'models')
                                                   }
                                               });

*/
