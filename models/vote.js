//var db = db.votes;

var Vote = exports = module.exports = function Vote(id, title, options) {
    thid.id = id;
    this.title = title;
    this.options = options;
    this.createdAt = new Date;
    this.version = 0;
};

Vote.prototype.save = function(fn) {
    this.version += 1;
    db[this.id] = this;
    fn();
};

Vote.prototype.validate = function(fn) {
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

Vote.prototype.update = function(data, fn) {
    this.updatedAt = new Date;
    for (var key in data) {
        if (undefined != data[key]) {
            this[key] = data[key];
        }
    }
    this.save(fn);
};

Vote.prototype.destroy = function(fn) {
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
