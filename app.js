var express = require('express'),
  app = express.createServer(),
  io = require('socket.io').listen(app),
  db = {};



app.configure(function() {
                  app.set('views', __dirname + '/views');
                  app.set('view engine', 'jade');
                  app.use(express.bodyParser());

                  require('./boot')(app, db);

                  app.use(app.router);
                  app.use(express.methodOverride());
                  app.use(express.logger({ format: ':method :url' }));
                  app.use(express.logger({ format: ':method :url' }));
                  app.use('/public', express.static(__dirname + '/public'));
                  app.use('/', express.static(__dirname + '/static/pages/index.html'));
                  app.use(express.cookieParser());
                  app.use(express.session({ secret: "keyboard cat" }));
                  app.use(express.errorHandler({dumpExceptions: true, showStack: true}));
});

app.listen(3000);

/*app.get('/', function(req, res) {
            res.render('index.jade', { title: 'Test!', pretty: false });
});

io.sockets.on('connection', function(socket) {
                  console.log('new connection');
                  socket.emit('welcome', { test: 'test' });
});*/

