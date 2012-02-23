var express = require('express'),
  app = express.createServer(),
  io = require('socket.io').listen(app),
  db = {
      users: [
          { id: 0, name: 'admin', email: 'm@42.am', role: 'admin' }
      ],
      votes: [
          {
              id: "test123",
              choices: {
                  "test": 123,
                  "test2": 1234,
                  "test3": 12,
                  "test4": 14
              }
          }, {
              id: "blah",
              choices: {
                  "aaa": 0,
                  "bbb": 0,
                  "ccc": 0,
                  "ddd": 0
              }
          }
      ]
  };


app.configure('development', function() {
                  app.set('jquery.js', '/public/js/jquery.min.js');
                  app.set('scriptio.js', '/public/js/socket.io.min.js');
                  app.set('pretty', true);
              });

app.configure('production', function() {
                  app.set('jquery.js', 'https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js');
                  app.set('scriptio.js', '/public/js/socket.io.min.js');
                  app.set('pretty', false);
              });

app.configure(function() {
                  app.set('views', __dirname + '/views');
                  app.set('view engine', 'jade');

                  app.use('/public', express.static(__dirname + '/public'));
                  app.use(app.router);

                  app.use(checkRequestHeaders);
                  app.use(express.bodyParser());
                  app.use(checkRequestData);
                  app.use(express.methodOverride());

                  app.use(express.logger({ format: ':method :url' }));

                  app.use(express.cookieParser('keyboard cat'));
                  app.use(express.session({ secret: "keyboard cat" }));

                  app.set('view options', {
                              jqueryjs: app.set('jquery.js'),
                              pretty: app.set('pretty')
                          });
});

app.configure('development', function() {
                  app.use(express.errorHandler({dumpExceptions: true, showStack: true}));
});

app.configure('production', function() {
                  app.use(express.errorHandler());
});

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

if (!module.parent) {
    var port = 3000;
    app.listen(port);
    console.log('Express started on port ' + port);
}

/*io.sockets.on('connection', function(socket) {
                  console.log('new connection');
                  socket.emit('welcome', { test: 'test' });
});*/

