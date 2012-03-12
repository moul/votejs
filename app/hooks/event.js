/**
 * Events
 */
exports.create_vote = function(data, req) {
    var pusher = req.app.set('pusher');
    pusher.vote.trigger('vote', data);
};

exports.update_vote = function(data, req) {
    var pusher = req.app.set('pusher');
    pusher.vote.trigger('vote', data);
};

exports.delete_vote = function(data, req) {
    var pusher = req.app.set('pusher');
    pusher.vote.trigger('vote', data);
};

exports.create_poll = function(data, req) {
    var pusher = req.app.set('pusher');
    pusher.poll.trigger('poll', data);
};

exports.update_poll = function(data, req) {
    var pusher = req.app.set('pusher');
    pusher.poll.trigger('poll', data);
};

exports.delete_poll = function(data, req) {
    var pusher = req.app.set('pusher');
    pusher.poll.trigger('poll', data);
};
