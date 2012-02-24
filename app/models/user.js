var mongoose = require('mongoose'),
sys = require('sys'),
schema = new mongoose.Schema({
                                 name: { type: String },
                                 date: { type: Date, default: Date.now }
                             });
mongoose.model('User', schema);