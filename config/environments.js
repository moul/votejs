/**
 * Load dependencies
 */
var Pusher = require('pusher');

/**
 * Exports
 */
module.exports = function(app) {
    var port = process.env.PORT || 1337
    , ___push;

    app.configure('local', function() {
                      // Setup Pusher
                      ___push = new Pusher({
                                               appId: 'xxx',
                                               appKey: 'xxx',
                                               secret: 'xxx'
                                           });

                      this
                          .set('host', 'localhost')
                          .set('port', port)
                          .set('ENV', 'local');
                  });

    app.configure('production', function() {
                      // Setup Pusher
                      ___push = new Pusher({
                                               appId: 'XXX',
                                               appKey: 'XXX',
                                               secret: 'XXX'
                                           });

                      this
                          .set('host', 'votejs.herokuapp.com')
                          .set('port', port)
                          .set('ENV', 'production');
                  });

    // Set Pusher
    app
        .set('pusher', { 'vote': ___push.channel('vote') })
        .set('pusher_key', ___push.options.appKey);

    return app;
};