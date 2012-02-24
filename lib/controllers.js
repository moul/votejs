module.exports = Server.controllers = {
    controller_objects: {}
};

Server.controllers.autoload = function(db) {
    var fs = require('fs'),
    path = require('path'),
    sys = require('sys'),
    files = fs.readdirSync(Server.paths.controllers),
    util = require('./util'),
    names = _.map(files, function(file) {
                      return path.basename(file);
                  });

    _.each(names, function(controller) {
               var c_id = util.camelize(controller.replace(/.js$/, ''));
               Server.controllers.controller_objects[c_id] = require(path.join(Server.paths.controllers, controller));
           });
};