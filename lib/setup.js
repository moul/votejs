
module.exports.setup = function(options) {
    var sys = require('sys'),
    app = options.app,
    socket = options.app.socket,
    mongoose = options.mongoose,
    io = options.io,
    express = options.express,
    config = options.config;

    Server.paths = options.paths;

    global.db = mongoose.connect('mongodb://localhost/votejs');

    require('./models.js').autoload(db);
    require('./controllers.js').autoload(db);
    require('./routes.js').draw(db);

    app.configure('development', function() {
                      app.set('jquery.js', '/public/js/jquery.min.js');
                      app.set('scriptio.js', '/js/socket.io.min.js');
                      app.set('pretty', true);
                  });

    app.configure('production', function() {
                      app.set('jquery.js', 'https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js');
                      app.set('scriptio.js', '/js/socket.io.min.js');
                      app.set('pretty', false);
                  });


    app.configure(function() {
                      app.set('views', options.paths.views);
                      app.set('view engine', 'jade');


                      //app.use(checkRequestHeaders);
                      app.use(express.bodyParser());
                      //app.use(checkRequestData);
                      app.use(express.methodOverride());

                      app.use(express.logger({ format: ':method :url' }));
                      //app.use(express.cookieParser('keyboard cat'));
                      //app.use(express.session({ secret: "keyboard cat" }));

                      app.set('view options', {
                                  jqueryjs: app.set('jquery.js'),
                                  pretty: app.set('pretty'),
                                  title: config.page.title
                              });

                      app.use(app.router);
                      app.use(express.static(options.paths.root));
                  });

    app.configure('development', function() {
                      app.use(express.errorHandler({dumpExceptions: true, showStack: true}));
                  });

    app.configure('production', function() {
                      app.use(express.errorHandler());
                  });


    app.listen(config.server.port || 3000, config.server.address);
    console.log('Express started on ' + config.server.address + ':' + (config.server.port || 3000));
};