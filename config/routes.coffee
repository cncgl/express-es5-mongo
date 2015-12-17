'use strict'

home = require '../app/controllers/home'
articles = require '../app/controllers/articles'

module.exports = (app) ->
  app.param('id', articles.load)
  app.get('/articles', articles.index)
  app.get('/articles/new', articles.new)
  app.post('/articles', articles.create)
  app.get('/articles/:id', articles.show)
  app.get('/articles/:id/edit', articles.edit)
  app.put('/articles/:id', articles.update)
  app.delete('/articles/:id', articles.destroy)

  app.get('/', home.index)
