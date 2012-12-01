exports.index = (req, res) ->
    args =
        debug: req.query.debug
        userId: req.query.userId || false
        pollId: req.query.pollId || false
    res.render 'app', args
