#!/usr/bin/env node
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
                                                   config: config,
                                                   paths: {
                                                       views: path.join(Server.root, 'app', 'views'),
                                                       controllers: path.join(Server.root, 'app', 'controllers'),
                                                       root: path.join(Server.root, 'public'),
                                                       models: path.join(Server.root, 'app', 'models')
                                                   }
                                               });


/*io.sockets.on('connection', function(socket) {
                  console.log('new connection');
                  socket.emit('welcome', { test: 'test' });
});*/

