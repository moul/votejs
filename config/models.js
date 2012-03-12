/**
 * Load dependencies
 */
const mongoose = require('mongoose');
require('express-mongoose');

/**
 * Exports
 */
module.exports = function() {
    // Load Vote model
    mongoose.model('Vote', require('../app/models/vote'));
    mongoose.model('Poll', require('../app/models/poll'));
};

/*
module.exports = Server.models = {};

Server.models.autoload = function(db) {
    var fs = require('fs'),
    path = require('path'),
    mongoose = require('mongoose'),
    sys = require('sys'),
    files = fs.readdirSync(Server.paths.models),
    names = _.map(files, function(file) {
                      return path.basename(file);
                  });
    _.each(names, function(model) {
               require(path.join(Server.paths.models, model));
    });
    sys.puts(sys.inspect(Server.models));
}
*/