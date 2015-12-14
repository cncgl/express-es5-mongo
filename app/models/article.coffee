# Example model

mongoose = require 'mongoose'
Schema   = mongoose.Schema

# Article Schema
ArticleSchema = new Schema(
  title: String
  url: String
  text: String
)

# validations
ArticleSchema.path('title').required(false, 'Article title cannot be blank')
ArticleSchema.path('text').required(false, 'Article text cannot be blank')


# ArticleSchema.virtual('date')
#  .get (-> this._id.getTimestamp())

# method
ArticleSchema.methods = {
  uploadAndSave: (image) ->
    err = @validateSync()
    if err && err.toString()
      throw new Error(err.toString())
    return @save()
}


# static
ArticleSchema.statics = {
  load: (_id) ->
    return @findOne {_id}
    # .populate('user', 'name email username')
    # .populate('comments.user')
    .exec()

  list: (options) ->
    criteria = options.criteria || {}
    page = options.page || 0
    limit = options.limit || 30
    return @find(criteria)
      .populate('user', 'name username')
      .sort({ createdAt: -1 })
      .limit(limit)
      .skip(limit * page)
      .exec()
}


console.log('load article')
mongoose.model('Article', ArticleSchema)

