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

exports.show = (req, res) ->
    res.jsonp 42

exports.list = (req, res) ->
    res.jsonp 43

io = null

exports.open = (app, tapas) ->
    io = tapas.io
    io.on 'connection', (socket) ->
        socket.on 'pollVotes', (data, fn = null) ->
            fn _list data.pollId

        socket.on 'pollOwnVote', (data, fn = null) ->
            fn _own data.pollId

        socket.on 'pollVoteCreate', (data, fn = null) ->
            _create data.pollId, data.answerId, data.userId

_create = (pollId, answerId, userId) ->
    console.log 'vote create !'
    max  = 0
    ownVote = ''
    ownIndex = 0
    console.log db.votes
    for key, vote of db.votes
        max = Math.max max, parseInt(key)
        if vote.userId is userId and vote.poll.toString() is pollId.toString()
            ownIndex = key
    console.log ownIndex
    if ownIndex and ownIndex != '0'
        console.log 'User already exist'
        db.votes[ownIndex].answer = answerId
    else
        console.log 'new user'
        db.votes[max + 1] =
            poll: pollId
            answer: answerId
            date: Date()
            userId: userId
    io.sockets.emit 'pollVotesUpdate',
        pollId: pollId,
        votes: _list pollId, userId

exports.create = (req, res) ->
    _create req.params.poll_id, req.body.answerId, req.body.userId
    res.jsonp db.votes[42]

getPoll = (pollId) ->
    return db.polls[pollId]

_list = (pollId) ->
    value = getPollVotes pollId
    for key, answer of getPoll(pollId).answers
        value[key] ?= 0
    return value

_own = (pollId, userId) ->
    return getPollOwnVote pollId, userId

exports.list_json = (req, res) ->
    res.jsonp _list req.poll.id, req.query.userId

exports.show_json = (req, res) ->
    args =
        poll: req.poll
        vote: req.vote
    res.jsonp args

getPollVotes = (pollId) ->
    votes = {}
    for key, vote of db.votes when parseInt(vote.poll) is parseInt(pollId)
        votes[vote.answer] ?=  0
        votes[vote.answer]++
    return votes

getPollOwnVote = (pollId, userId) ->
    for key, vote of db.votes
        if vote.userId.toString() is userId.toString() && vote.poll is parseInt(pollId)
            console.log 'user Found'
            ownVote = vote
    return ownVote || false
