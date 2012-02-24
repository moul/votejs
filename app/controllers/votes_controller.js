module.exports = actions = {};

actions.index = function(req, res) {
    res.send({
                 bla: 42,
                 bli: 41
             });
};