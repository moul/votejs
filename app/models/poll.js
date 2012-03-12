/**
 * Load dependencies
 */
const Schema = require('mongoose').Schema
, ObjectId = Schema.ObjectId;

/**
 * Exports
 */
var Poll = module.exports = new Schema({
                                           title: { type: String, required: true },
                                           options: { type: String, required: true, default: '{}' },
                                           date_created: { type: Date, default: Date.now },
                                           date_updated: { type: Date },
                                           is_active: { type: Boolean, default: true },
                                           body: { type: String, required: false }
});

/**
 * Statics
 */
Poll.statics.getLatestPolls = function(callback) {
    return this.find().sort('_id', 'descending').limit(15).find({}, callback);
};

/**
 * Hooks
 */
// this happens before it saves
Poll.pre('save', function(next) {
             console.log('Saving...');
             next();
         });

// this happens before it removes
Poll.pre('remove', function(next) {
             console.log('Removing...');
             next();
         });

// This happens when it initializes
Poll.pre('init', function(next) {
             console.log('Initializing...');
             next();
         });

/**
 * Old code
 */
/*//var db = db.polls;

var Poll = exports = module.exports = function Poll(id, title, options) {
    thid.id = id;
    this.title = title;
    this.options = options;
    this.createdAt = new Date;
    this.version = 0;
};

Poll.prototype.save = function(fn) {
    this.version += 1;
    db[this.id] = this;
    fn();
};

Poll.prototype.validate = function(fn) {
    if (!this.id) {
        return fn(new Error('id required'));
    }
    if (!this.title) {
        return fn(new Error('title required'));
    }
    if (!this.options) {
        return fn(new Error('options required'));
    }
    if (this.options.length < 1) {
        return fn(new Error('options should have at least 1 entries, was only ' + this.options.length));
    }
    fn();
};

Poll.prototype.update = function(data, fn) {
    this.updatedAt = new Date;
    for (var key in data) {
        if (undefined != data[key]) {
            this[key] = data[key];
        }
    }
    this.save(fn);
};

Poll.prototype.destroy = function(fn) {
    exports.destroy(this.id, fn);
};

exports.count = function(fn) {
    fn(null, Object.keys(db).length);
};

exports.all = function(fn) {
    var arr = Object.keys(db).reduce(function(arr, id) {
                                         arr.push(db[id]);
                                         return arr;
                                     }, []);
    fn(null, arr);
};

exports.get = function(id, fn) {
    fn(null, db[id]);
};

exports.destroy = function(id, fn) {
    if (db[id]) {
        delete db[id];
        fn();
    } else {
        fn(new Error('post ' + id + ' does not exist'));
    }
};
*/