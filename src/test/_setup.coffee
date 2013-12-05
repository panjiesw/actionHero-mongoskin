exports._setup =
  serverPrototype: require('../node_modules/actionHero/actionHero.js').actionHeroPrototype
  testUrl: 'http://127.0.0.1:9000'
  serverConfigChanges:
    general:
      id: "test-server-1"
      workers: 1
      developmentMode: false
    logger: transports: null
    redis:
      fake: true
      host: "127.0.0.1"
      port: 6379
      password: null
      options: null
      DB: 0
    servers:
      web:
        secure: false,
        port: 9000

  init: (callback) ->
    self = this
    if self.server is undefined or self.server is null
      self.server = new self.serverPrototype()
      self.server.start
        configChanges: self.serverConfigChanges
      , (err, api) ->
        self.api = api
        callback()
    else
      self.server.restart ->
        callback()
