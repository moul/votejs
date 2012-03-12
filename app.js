#!/usr/bin/env node

var path = require('path');

try {
    require.paths = require.paths.unshift(__dirname + '/../node_modules');
} catch (x) {
    process.env.NODE_PATH = path.join(__dirname, '/../node_modules') + ':' + process.env.NODE_PATH;
}

require('./lib/exceptions');

if (!process.env.NODE_ENV) {
    process.env.NODE_ENV = "local";
}

var app = require('./config/app')();
app.listen(app.set('port'));

console.log('\x1b[36mVote system\x1b[90m v%s\x1b[0m running as \x1b[1m%s\x1b[0m on http://%s:%d',
  app.set('version'),
  app.set('env'),
  app.set('host'),
  app.address().port
);

/*io.sockets.on('connection', function(socket) {
                  console.log('new connection');
                  socket.emit('welcome', { test: 'test' });
});*/

