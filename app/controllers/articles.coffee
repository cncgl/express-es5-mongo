'use strict'

mongoose = require 'mongoose'
assign = require 'object-assign'
wrap = require 'co-express'
only = require 'only'
Article = mongoose.model 'Article'


# load
exports.load = wrap( (req, res, next, id) ->
  console.log('id: ' + id)
  req.article = yield Article.load(id)
  unless req.article
    return next(new Error('Article not found'))
  next()
)

# list
exports.index = wrap( (req, res) ->
  limit = 30
  options = {
    limit: limit
  }
  articles = yield Article.list(options)

  res.render('articles/index', {
    title: 'Articles',
    articles: articles
  })
)

# new
exports.new = (req, res) ->
  res.render 'articles/new', {
    title: 'New Article'
    article: new Article {}
  }

# create
exports.create = wrap( (req, res) ->
  console.log('req.body ' + req.body)
  article = new Article(only(req.body, 'title url text'))

  # article.user = req.user
  yield article.uploadAndSave()
  req.flash 'success', 'Successfully created article!'
  res.redirect('/articles/' + article._id)
)

# edit
exports.edit = (req, res) ->
  res.render 'articles/edit', {
    title: 'Edit ' + req.article.title
    article: req.article
  }

# update
exports.update = wrap( (req, res) ->
  console.log('req.article ' + req.article)
  article = req.article

  assign article, only(req.body, 'title url text')
  yield article.uploadAndSave()
  res.redirect('/articles/' + article._id)
)

# show
exports.show = (req, res) ->
  console.log('req.article ' + req.article)
  res.render 'articles/show', {
    title: req.article.title
    article: req.article
  }

# delete
exports.destroy = wrap( (req, res) ->
  yield req.article.remove()
  req.flash 'success', 'Deleted successfully'
  res.redirect('/articles')
)
