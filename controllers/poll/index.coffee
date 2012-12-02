db = require '../../db'

getPolls = ->
    polls = []
    for poll_id, poll of db.polls
        if not poll.private
            polls.push
                id: poll.id
                question: poll.question
    return polls

getPoll = (pollId) ->
    return db.polls[pollId]

createPoll = (question, answers) ->
    if answers.length >= 2
        max = 0
        max = Math.max max, key for key, poll of db.polls
        answersTmp = {}
        for answer, index in answers
            answersTmp[index.toString()] = answer
        db.polls[max + 1] =
            id: max + 1
            question: question
            answers: answersTmp
        console.log db.polls
exports.before = (req, res, next) ->
    console.log 'poll before !'
    id = req.params.poll_id
    if not id
        return do next
    process.nextTick ->
        poll = getPoll pollId
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

exports.open = (app, tapas) ->
    tapas.io.on 'connection', (socket) ->
        socket.on 'polls', (data, fn = null) ->
            polls = getPolls()
            fn polls if fn

        socket.on 'poll', (data, fn = null) ->
            poll = getPoll parseInt data.pollId
            fn poll if fn
        socket.on 'pollCreate', (data, fn = null) ->
            createPoll data.question, data.answers

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
