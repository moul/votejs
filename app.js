_ = require('./lib/underscore/underscore');

var Server = {},
express = require('express'),
path = require('path'),
sys = require('sys'),
config = require('./config');

Server.root = __dirname,
global.Server = Server,
global.app = express.createServer();

Server.setup = require('./lib/setup.js').setup({
                                                   app: app,
                                                   mongoose: require('mongoose'),
                                                   io: require('socket.io'),
                                                   express: express,
                                                   paths: {
                                                       views: path.join(Server.root, 'app', 'views'),
                                                       root: path.join(Server.root, 'app', 'public'),
                                                       controllers: path.join(Server.root, 'app', 'controllers'),
                                                       models: path.join(Server.root, 'app', 'models')
                                                   }
                                               });

/*
var express = require('express'),
  app = express.createServer(),
  config = require('./config'),
  io = require('socket.io').listen(app),
  mongoose = require('mongoose'),
  db = mongoose.connect(config.mongo.db),
  Schema = mongoose.Schema;

function checkRequestHeaders(req, res, next) {
    if (!req.accepts('application/json')) {
        return res.respond('You must accept content-type application/json', 406);
    }
    if ((req.method == "PUT" || req.method == "POST") && req.header('content-type') != 'application/json') {
        return res.respond('You must declare your content-type as application/json', 406);
    }
    return next();
};

function checkRequestData(req, res, next) {
    next();
}

require('./routes/site')(app, db);
require('./routes/vote')(app, db);


*/











/*io.sockets.on('connection', function(socket) {
                  console.log('new connection');
                  socket.emit('welcome', { test: 'test' });
});*/

