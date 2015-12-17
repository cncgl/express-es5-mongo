'use strict'

home = require '../app/controllers/home'
articles = require '../app/controllers/articles'

articleAuth = [];

module.exports = (app) ->
  app.param('id', articles.load)
  app.get('/articles', articles.index)
  # app.get('/articles/new', auth.requiresLogin, articles.new)
  # app.post('/articles', auth.requiresLogin, articles.create)
  # app.get('/articles/:id', articles.show)
  # app.get('/articles/:id/edit', articleAuth, articles.edit)
  # app.put('/articles/:id', articleAuth, articles.update)
  # app.delete('/articles/:id', articleAuth, articles.destroy)
  app.get('/articles/new', articles.new)
  app.post('/articles', articles.create)
  app.get('/articles/:id', articles.show)
  app.get('/articles/:id/edit', articles.edit)
  app.put('/articles/:id', articles.update)
  app.delete('/articles/:id', articles.destroy)

  app.get('/', home.index)
