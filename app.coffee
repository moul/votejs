#!/usr/bin/env coffee

config = require './config'
tapas = require('tapas') config.tapas
tapas = do tapas.app

do tapas.run
