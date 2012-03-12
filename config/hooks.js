/**
 * Load hooks
 */
var ev = require('../app/hooks/event');

/**
 * Exports
 */
// Namespacing is recommended
module.exports = function(app) {
    // Event hooks
    app.on('event:create_vote', ev.create_vote);
    app.on('event:update_vote', ev.update_vote);
    app.on('event:delete_vote', ev.delete_vote);

    app.on('event:create_poll', ev.create_poll);
    app.on('event:update_poll', ev.update_poll);
    app.on('event:delete_poll', ev.delete_poll);
};