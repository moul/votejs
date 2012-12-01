db = require '../../db'

exports.prefix = '/poll/:poll_id'

exports.before = (req, res, next) ->
    console.log 'vote_before !'
    id = req.params.vote_id
    if not id
        return do next
    process.nextTick ->
        vote = db.votes[id]
        if not vote
            res.json {
                error: true
                message: 'Vote not found'
                }, 404
            return
        req.vote = vote
        if req.vote.poll != req.poll?.id
            res.json
                error: true
                message: 'bad poll or vote id'
            return
        do next

exports.create = (req, res) ->
    console.log 'vote create !'
    res.jsonp
        poll: req.poll
        userId: req.body.userId
        answerId: req.
        body.answerId

exports.list_json = (req, res) ->
    args =
        votes: [42, 43]
        poll: req.poll
    res.jsonp args

exports.show_json = (req, res) ->
    args =
        poll: req.poll
        vote: req.vote
    res.jsonp args
