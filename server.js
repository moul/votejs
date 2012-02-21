var express = require('express'),
app = express.createServer(),
io = require('socket.io').listen(app);

app.listen(8009);

app.configure(function() {
    app.use(app.router);
    app.set('view engine', 'jade');
    //app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(express.logger({ format: ':method :url' }));
    app.use(express.logger({ format: ':method :url' }));
    app.use('/static', express.static(__dirname + '/static'));
    app.use('/', express.static(__dirname + '/static/pages/index.html'));
    app.use(express.cookieParser());
    app.use(express.session({ secret: "keyboard cat" }));
    app.use(express.errorHandler({dumpExceptions: true, showStack: true}));
});

app.get('/', function(req, res) {
    res.render('index.jade', { title: 'Test!', pretty: false });
});

io.sockets.on('connection', function(socket) {
    console.log('new connection');
    socket.emit('welcome', { test: 'test' });
});

