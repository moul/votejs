exports.index = (req, res) ->
    args =
        debug: req.query.debug
    res.render 'app', args
