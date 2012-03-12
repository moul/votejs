/**
 * Load dependencies
 */
var pusher = require('pusher')
, controller = {}
, app
, db;

/**
 * Exports
 */
module.exports = function(_app) {
    app = _app;
    db = app.set('db');
    return controller;
};

/**
 * Routes callbacks
 */
controller.index = function(req, res, next) {
    // expose pusher key
    res.expose({
                   app_key: req.app.set('pusher_key'),
                   channel: 'vote',
                   events: 'vote'
               });

    // render template
    res.render('home', {
                   polls: db.polls.getLatestPolls(),
                   votes: db.votes.getLatestVotes()
               });
};

controller.create = function(req, res, next) {
    // TODO
};

controller.update = function(req, res, next) {
    // TODO
};

controller.delete = function(req, res, next) {
    // TODO
};