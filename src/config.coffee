###
# #Config File
# I will be loded into api.configData. This particular `config.js` file will only be loaded in
# development.
###

# *****

###
# Requires
###
fs = require("fs")
cluster = require("cluster")
configData = {}

###
# ##General Config Section
###
configData.general =
  # The version of API Server
  apiVersion: "0.0.1"
  serverName: "actionHero API"
  # } id: "myActionHeroServer" // id can be set here, or it will be generated dynamically.  Be sure that every server you run has a unique ID (which will happen when genrated dynamically).
  # A unique token to your application that servers will use to authenticate to each other.
  serverToken: "change-me"
  # The welcome message seen by TCP and webSocket clients upon connection.
  welcomeMessage: "Hello! Welcome to the actionHero api"
  # The body message to accompany 404 (file not found) errors regarding flat files.
  flatFileNotFoundMessage: "Sorry, that file is not found :("
  # The message to accompany 500 errors (internal server errors).
  serverErrorMessage: "The server experienced an internal error"
  # The chatRoom that TCP and webSocket clients are joined to when the connect.
  defaultChatRoom: "defaultRoom"
  # DefaultLimit & defaultOffset are useful for limiting the length of response lists.
  defaultLimit: 100
  defaultOffset: 0
  # Watch for changes in actions and tasks, and reload/restart them on the fly. Set it to `no` in production.
  developmentMode: yes
  # How many pending actions can a single connection be working on.
  simultaneousActions: 5
  # Configuration for your actionHero project structure.
  paths:
    action: __dirname + "/actions"
    task: __dirname + "/tasks"
    public: __dirname + "/public"
    pid: __dirname + "/pids"
    log: __dirname + "/log"
    server: __dirname + "/servers"
    initializer: __dirname + "/initializers"

# *****

###
# ##Logging Config Section
###
configData.logger = transports: []

# Console logger for master cluster.
if cluster.isMaster
  configData.logger.transports.push (api, winston) ->
    new (winston.transports.Console)(
      colorize: yes
      level: "debug"
      timestamp: api.utils.sqlDateTime
    )


# File logger.
try
  fs.mkdirSync "./log"
catch e
  unless e.code is "EEXIST"
    console.log e
    process.exit()
configData.logger.transports.push (api, winston) ->
  new (winston.transports.File)(
    filename: configData.general.paths.log + "/" + api.pids.title + ".log"
    level: "info"
    timestamp: yes
  )

# *****

###
# ##Stats Config Section
###
configData.stats =
  # How often should the server write its stats to redis?
  writeFrequency: 1000
  # What redis key(s) [hash] should be used to store stats? provide no key if you do not want to store stats.
  keys: ["actionHero:stats"]

# *****

###
# ##MongoDB Config Section
###
configData.mongo =
  # Run database seed if `yes`. Set to `no` in production.
  seed: yes
  host: "localhost"
  port: 27017
  db: "test"
  user: ""
  pass: ""

# *****

###
# ##Redis Config Section
###
configData.redis =
  # Run fake redis in development. Set to `no` in production.
  fake: yes
  host: "127.0.0.1"
  port: 6379
  password: null
  options: null
  database: 0

# *****

###
# ##Faye Config Section
# Faye is a publish-subscribe messaging system based on the [Bayeux](http://svn.cometd.com/trunk/bayeux/bayeux.html) protocol. It provides message servers for Node.js and Ruby, and clients for use on the server and in all major web browsers.
###
configData.faye =
  # Faye's URL mountpoint.  Be sure to not overlap with an action or route/
  mount: "/faye"
  # Idle timeout for clients/
  timeout: 45
  # Should clients ping the server?
  ping: null
  # What redis server should we connet to for faye?
  redis: configData.redis
  # Redis prefix for faye keys/
  namespace: "faye:"

# *****

###
# ##Tasks Config Section
# See https://github.com/taskrabbit/node-resque for more information / options.
###
configData.tasks =
  # Should this node run a scheduler to promote delayed tasks?
  scheduler: yes
  # What queues should the workers work and how many to spawn? "['*']" is one worker working the * queue; "['high,low']" is one worker woring 2 queues.
  queues: ["*"]
  # How long to sleep between jobs / scheduler checks.
  timeout: 5000
  # What redis server should we connet to for tasks / delayed jobs?
  redis: configData.redis

# *****

###
# ##Servers Config Section
# Uncomment the section to enable the server.
###

configData.servers =

  # Webserver Config
  web:
    # HTTP or HTTPS?
    secure: no
    # Passed to https.createServer if secure=ture. Should contain SSL certificates.
    serverOptions: {}
    # Port or Socket.
    port: 8080
    # Which IP to listen on (use 0.0.0.0 for all).
    bindIP: "0.0.0.0"
    # Any additional headers you want actionHero to respond with.
    httpHeaders:
      "Access-Control-Allow-Origin": "*"
      "Access-Control-Allow-Methods": "HEAD, GET, POST, PUT, DELETE, OPTIONS, TRACE"
      "Access-Control-Allow-Headers": "Content-Type, X-Requested-With, Origin"

    ###
    # Route that actions will be served from; secondary route against this route will be treated as actions,
    #
    # IE: `/api/?action=test == /api/test/ .`
    ###
    urlPathForActions: "api"
    # Route that static files will be served from; path (relitive to your project root) to server static content from.
    urlPathForFiles: "public"
    # When visiting the root URL, should visitors see "api" or "file"? Visitors can always visit /api and /public as normal.
    rootEndpointType: "api"
    # The default filetype to server when a user requests a directory.
    directoryFileType: "index.html"
    # The header which will be returned for all flat file served from /public; defined in seconds.
    flatFileCacheDuration: 60
    # Settings for determining the id of an http(s) requset (browser-fingerprint).
    fingerprintOptions:
      cookieKey: "sessionID"
      toSetCookie: yes
      onlyStaticElements: no

    # Options to be applied to incomming file uplaods. More options and details at https://github.com/felixge/node-formidable.
    formOptions:
      uploadDir: "/tmp"
      keepExtensions: no
      maxFieldsSize: 1024 * 1024 * 100

    # Options to configure metadata in responses.
    metadataOptions:
      serverInformation: yes
      requestorInformation: yes

    # When true, returnErrorCodes will modify the response header for http(s) clients if connection.error is not null. You can also set connection.responseHttpCode to specify a code per request.
    returnErrorCodes: no

  # Websocket server config
  websocket: {}

  # Socket server config
  # } socket : {
  # }   secure: no,                        // TCP or TLS?
  # }   serverOptions: {},                    // passed to tls.createServer if secure=ture. Should contain SSL certificates
  # }   port: 5000,                           // Port or Socket
  # }   bindIP: "0.0.0.0",                    // which IP to listen on (use 0.0.0.0 for all)
  # } },

# *****

exports.configData = configData
