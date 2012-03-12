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
