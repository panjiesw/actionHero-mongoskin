###
# #MongoSkin Initializer
# *__Author__: Panjie SW <panjie@panjiesw.com>*
# *__Project__: actionHero-mongoskin*
#
# Provides MongoDB connection initialization via MongoSkin and shortcut functions.
# You can easily add others or modify this as needed by overriding the initializer.
# *********************************************
###

mongodb = require 'mongoskin'

###
# Expose some of mongo driver object to `api.mongo` so we can use them
# again later without requiring the driver.
###
mongo =
  ObjectID: mongodb.ObjectID
  ObjectId: mongodb.ObjectID
  Timestamp: mongodb.Timestamp
  router: mongodb.router
  Cursor: mongodb.Cursor
  GridStore: mongodb.GridStore
  dbSeed: (next) ->
    next()

mongo._start = (api, next) ->
  config = api.configData.mongo

  api.mongo.db = mongodb.db(
    "#{config.user}:#{config.pass}@#{config.host}:#{config.port}/#{config.db}",
    w: 1
  )
  api.mongo.db.open (err, db) ->
    if err
      api.log "Error opening MongoDB Connection: #{err.message}", 'error'
      api.log err.stack, 'error'
      process.exit 1
    api.mongo.toObjectId = api.mongo.toId = api.mongo.db.toId
    api.mongo.collection = api.mongo.db.collection
    api.log "MongoDB connection opened", 'debug'
    if config.seed
      api.log "Seed set to true, dropping database first"
      api.mongo.db.dropDatabase (err, done) ->
        if err
          api.log "Error dropping database", 'warning'
          api.log err.stack, 'error'
        else
          api.mongo.dbSeed next
    else
      next()

mongo._teardown = (api, next) ->
  api.mongo.db.close (err, db) ->
    api.log "MongoDB connection closed", 'debug'
    next()

exports.mongo = mongo

exports.mongoinit = (api, next) ->
  api.mongo = mongo
  next()
