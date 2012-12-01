exports.index = (req, res) ->
    args =
        debug: req.query.debug
        userId: req.query.userId || false
    res.render 'app', args
