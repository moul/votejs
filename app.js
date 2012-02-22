var express = require('express'),
  app = express.createServer(),
  io = require('socket.io').listen(app),
  db = {
      users: [
          { id: 0, name: 'admin', email: 'm@42.am', role: 'admin' }
      ]
  };


app.configure(function() {
                  app.set('views', __dirname + '/views');
                  app.set('view engine', 'jade');
                  app.use(express.bodyParser());

                  app.use(express.methodOverride());
                  app.use(express.logger({ format: ':method :url' }));
                  app.use(express.errorHandler({dumpExceptions: true, showStack: true}));

                  app.use(express.cookieParser('keyboard cat'));
                  app.use(express.session({ secret: "keyboard cat" }));

                  app.use(app.router);
                  app.use('/public', express.static(__dirname + '/public'));
});

require('./routes/site')(app, db);
require('./routes/vote')(app, db);

if (!module.parent) {
    var port = 3000;
    app.listen(port);
    console.log('Express started on port ' + port);
}

/*io.sockets.on('connection', function(socket) {
                  console.log('new connection');
                  socket.emit('welcome', { test: 'test' });
});*/

