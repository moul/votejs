var mongoose = require('mongoose');

module.exports = actions = {};

user = mongoose.model('User');

actions.index = function(req, res) {
    user.find({}, function(err, docs) {
                  res.render('index', {
                                 bli: 42,
                                 bla: 43
                             });
              });
};
