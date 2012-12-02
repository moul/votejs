#!/usr/bin/env coffee

config = require './config'
tapas = exports.tapas = require('tapas')(config.tapas).app()

#tapas.io.on 'connection', (socket) ->
#    socket.on 'polls', (data, fn) ->
#        console.log 'onPolls', data
#        fn Math.random()

# clear terminal
process.stdout.write '\u001B[2J\u001B[0;0f'

tapas.autodiscover './controllers',
    order: ['poll', 'vote']

#tapas.app.set 'jsonp callback', true

do tapas.run
