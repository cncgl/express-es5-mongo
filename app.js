require('coffee-script/register');

var express = require('express'),
  config = require('./config/config'),
  glob = require('glob'),
  fs = require('fs'),
  join = require('path').join,
  models = join(__dirname, 'app/models'),
  mongoose = require('mongoose'),
  app = express();



//mongoose.connect(config.db);
//var db = mongoose.connection;
//db.on('error', function () {
//  throw new Error('unable to connect to database at ' + config.db);
//});

// var models = glob.sync(config.root + '/app/models/*.coffee');
// models.forEach(function (model) {
//   require(model);
// });

// Bootstrap models
fs.readdirSync(models)
  .filter( function(file) { return file.substr(-3) === '.js'; } )
  .forEach( function(file) { require(join(models, file)); } );

// Bootstrap routes
require('./config/express')(app, config);
require('./config/routes')(app);

connect()
  .on('error', console.log)
  .on('disconnected', connect)
  .once('open', listen);

// app.listen(config.port, function () {
//  console.log('Express server listening on port ' + config.port);
// });

function listen () {
  if (app.get('env') === 'test') return;
  app.listen(config.port);
  console.log('Express app started on port ' + config.port);
}

function connect () {
  var options = { server: { socketOptions: { keepAlive: 1 } } };
  return mongoose.connect(config.db, options).connection;
}
