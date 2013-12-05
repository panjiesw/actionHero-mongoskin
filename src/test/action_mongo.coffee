request = require 'request'
should = require 'should'
setup = require('./_setup')._setup

describe 'Testing mongodb connection', ->

  before (done) -> setup.init done

  it 'Should be able to connect via direct api', (done) ->
    setup.api.mongo.db.collection('foo').find {}, (err, result) ->
      should.not.exist err
    done()
