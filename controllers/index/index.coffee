db = require '../../db'

exports.index = (req, res) ->
    args =
        iourl: db.iourl
        debug: req.query.debug
        userId: req.query.userId || false
        pollId: req.query.pollId || false
    res.render 'app', args
