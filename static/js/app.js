$(document).ready(function() {
    var socket = io.connect();

    socket.on('connect', function() {
      console.log('connected');
    });

    socket.on('welcome', function(msg) {
      consooe.info('welcome', msg);
    });
});  
