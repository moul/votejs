db = require '../../db'

getPolls = ->
    polls = []
    for poll_id, poll of db.polls
        if not poll.private
            polls.push
                id: poll.id
                question: poll.question
    return polls

exports.before = (req, res, next) ->
    console.log "TEST2"
    id = req.params.poll_id
    if not id
        return do next
    process.nextTick ->
        poll = db.polls[id]
        if not poll
            res.json {
                error: true
                message: 'Poll not found'
                }, 404
            return
        if poll.private and poll.secret != req.query.secret
            res.json {
                error: true
                message: 'Poll is private'
                }, 403
            return
        req.poll = poll
        do next

## LIST
exports.list = (req, res) ->
    args =
        polls: getPolls()
    res.render 'list', args

exports.list_json = (req, res) ->
    res.jsonp getPolls()

## SHOW
exports.show = (req, res) ->
    args =
        poll: req.poll
    res.render 'show', args

exports.show_json = (req, res) ->
    res.jsonp req.poll

## JUNK

#exports.edit = (req, res) ->
#    res.json 'yo'

#exports.create = (req, res) ->
#    res.json "tesatoij"

#exports.update = (req, res) ->
#    res.json 'alskdgjasldg'

exports.custom = []
#exports.custom.push
#    path: '/poll/:poll_id/test'
#    callback: (req, res) ->
#        db.polls[42] =
#            question: 'yo'
#            answers: []
#            id: 42
#        res.json 'ok'

exports.locals =
    regions:
        navbarLinks:
            '/polls': 'Polls'
