# Example model

mongoose = require 'mongoose'
Schema   = mongoose.Schema

ArticleSchema = new Schema(
  title: String
  url: String
  text: String
)

ArticleSchema.virtual('date')
  .get (-> this._id.getTimestamp())


# static
ArticleSchema.statics = {
  load: (_id) ->
    return @findOne {_id}
    .populate('user', 'name email username')
    .populate('comments.user')
    .exec

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



mongoose.model 'Article', ArticleSchema

