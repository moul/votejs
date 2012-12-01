#!/usr/bin/env coffee

config = require './config'
tapas = require('tapas')(config.tapas).app()

# clear terminal
process.stdout.write '\u001B[2J\u001B[0;0f'

tapas.autodiscover './controllers'

#tapas.app.set 'jsonp callback', true

do tapas.run
