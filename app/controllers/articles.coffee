'use strict'

mongoose = require 'mongoose'
Article = mongoose.model 'Article'
wrap = require 'co-express'

exports.load = wrap( (req, res, next, id) ->
  req.article = yield Article.load(id)
  unless req.article
    return next(new Error('Article not found'))
  next()
)


