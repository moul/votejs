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

exports.create = (req, res) ->
    console.log 'vote create !'
    db.votes[42] =
        poll: req.params.poll_id
        answer: req.body.answerId
        date: Date()
        user: req.body.userId
    res.jsonp db.votes[42]

exports.list_json = (req, res) ->
    req.poll = db.polls[req.params.poll_id]
    console.log 'vote list body:', req.body
    args =
        votes: getPollVotes req.poll.id
        own: getPollOwnVote req.poll.id, req.body.userId
        poll: req.poll
    res.jsonp args

exports.show_json = (req, res) ->
    args =
        poll: req.poll
        vote: req.vote
    res.jsonp args

getPollVotes = (pollId) ->
    #poll = db.polls[req.params.poll_id]
    votes = {}
    votes[key] = vote for key, vote of db.votes when parseInt(vote.poll) is parseInt(pollId)
    
    return votes  

getPollOwnVote = (pollId, userId) ->
    console.log pollId, userId
    
    for key, vote of db.votes
        console.log vote
        if vote.userId is parseInt(userId) && vote.poll is parseInt(pollId)
            console.log 'user Found'
            ownVote = vote
    return ownVote || false
