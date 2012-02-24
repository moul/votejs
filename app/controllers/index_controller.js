var mongoose = require('mongoose');

module.exports = actions = {};

user = mongoose.model('User');

actions.index = function(req, res) {
    user.find({}, function(err, docs) {
                  res.render('index', {
                                 title: 'user',
                                 bla: 43
                             });
              });
};
