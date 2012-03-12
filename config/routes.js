/**
 * Exports
 */
module.exports = function(app) {
    var vote = require('../app/controllers/vote_controller')(app);
    var poll = require('../app/controllers/poll_controller')(app);
    var db = app.set('db');

    app.get('/', poll.index);
    app.get('/polls', vote.polls);
    app.get('/votes', vote.votes);
    app.get('/create', vote.create);
    app.get('/update', vote.update);
    app.get('/delete', vote.delete);
};

/**
 * Old code
 */
/*
var match = function(url,handler,method){

    handler = handler || "site#index";

    var parts = handler.split(/\#/),
    util = require("./util"),
    controller = parts.shift(),
    action = parts.shift(),
    sys = require('sys'),
    method = method || "get";

    //sys.puts(sys.inspect(controller));

    if(!controller.match(/_controller$/)){

        if (controller == 'site') {

            controller = 'Index';
        }
        controller = controller + "Controller";
    }

    sys.puts(sys.inspect(Server.controllers.controller_objects));
    sys.puts(sys.inspect(controller));

    var controller_id = util.camelize(controller),
    action_handler = Server.controllers.controller_objects[controller][action];

    //add the handler for the url
    if(url && action_handler){

        app[method](url,action_handler);
    }
};

var resource = function(resource_name){

};

module.exports.draw = function(app){
    match("/");
};
*/