var mongoose = require('mongoose'),
sys = require('sys'),
schema = new mongoose.Schema({
                                 name: { type: String },
                                 date: { type: Date, default: Date.now }
                             });
var userMod = mongoose.model('User', schema);

userMod.find({}, function(err, records) {
                 records.forEach(function(record) {
                                     console.log("Record found:" + record.name);
                                 });
             });

