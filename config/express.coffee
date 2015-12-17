express = require 'express'
glob = require 'glob'

favicon = require 'serve-favicon'
logger = require 'morgan'
session = require 'express-session'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
compress = require 'compression'
methodOverride = require 'method-override'
mongoStore = require('connect-mongo')(session)
flash = require 'connect-flash'
pkg = require '../package.json'


module.exports = (app, config) ->
  env = process.env.NODE_ENV || 'development'
  app.locals.ENV = env;
  app.locals.ENV_DEVELOPMENT = env == 'development'

  # Jade templating engine
  app.set 'views', config.root + '/app/views'
  app.set 'view engine', 'jade'

  # app.use(favicon(config.root + '/public/img/favicon.ico'));
  app.use logger 'dev'
  app.use bodyParser.json()
  app.use bodyParser.urlencoded(
    extended: true
  )

  # body parser
  app.use methodOverride (req) ->
    console.log('method-override ' + req.body )
    if req.body and typeof req.body == 'object' and req.body._method
      method = req.body._method
      delete req.body._method
      console.log('method ' + method)
      method


  # cookie parser
  app.use cookieParser()
  app.use compress()
  app.use express.static config.root + '/public'
  app.use(session({
    resave: true,
    saveUninitialized: true,
    secret: pkg.name,
    store: new mongoStore({
      url: config.db,
      collection : 'sessions'
    })
  }));

  #
  app.use(flash())

  # controllers = glob.sync config.root + '/app/controllers/**/*.coffee'
  # controllers.forEach (controller) ->
  #  require(controller)(app)

  # catch 404 and forward to error handler
  app.use (req, res, next) ->
    # err = new Error 'Not Found'
    # err.status = 404
    # next err
    next()

  # error handlers

  # development error handler
  # will print stacktrace

  if app.get('env') == 'development'
    app.use (err, req, res) ->
      res.status err.status || 500
      res.render 'error',
        message: err.message
        error: err
        title: 'error'

  # production error handler
  # no stacktraces leaked to user
  app.use (err, req, res) ->
    res.status err.status || 500
    res.render 'error',
      message: err.message
      error: {}
      title: 'error'
