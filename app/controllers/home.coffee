'use strict'

mongoose = require 'mongoose'
Article  = mongoose.model 'Article'

exports.index = (req, res) ->
  Article.find (err, articles) ->
    res.render 'index',
      title: 'Generator-Express MVC'
      articles: articles
