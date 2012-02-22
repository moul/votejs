var basicAuth = require('express').basicAuth,
Vote = require('../models/vote');

function andRestrictToSelf(req, res, next) {
    next();
}

function andRestrictTo(role) {
    return function(req, res, next) {
        if (req.authenticatedUser.role == role) {
            next();
        } else {
            next(new Error('Unauthorized'));
        }
    };
}

module.exports = function(app) {
    app.get('/vote/list', function(req, res) {
                res.render('list', { title: 'Test!', pretty: false });
            });

    app.get('/vote/admin', function(req, res) {
                res.redirect('/vote/admin/list');
            });

    app.get('/vote/admin/list', function(req, res) {
                res.render('admin/list', { title: 'Test!', pretty: false });
            });
};