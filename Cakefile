fs            = require 'fs'
{spawn, exec} = require 'child_process'

try
  which = require('which').sync
catch err
  if process.platform.match(/^win/)?
    console.log 'WARNING: the which module is required for windows\ntry: npm install which'
  which = null

files = [
  '.'
  'src'
]


# ANSI Terminal Colors
bold  = '\x1B[0;1m'
red   = '\x1B[0;31m'
green = '\x1B[0;32m'
reset = '\x1B[0m'


# Cakefile Tasks
#
# ## *docs*
#
# Generate Annotated Documentation
#
# <small>Usage</small>
#
# ```
# cake docs
# ```
task 'docs', 'generate documentation', -> groc()


# ## *build*
#
# Builds Source
#
# <small>Usage</small>
#
# ```
# cake build
# ```
task 'build', 'compile source', -> groc -> build -> log ":)", green


# ## *watch*
#
# Builds your source whenever it changes
#
# <small>Usage</small>
#
# ```
# cake watch
# ```
task 'watch', 'compile and watch', -> build true, -> log ":-)", green


# ## *test*
#
# Runs your test suite.
#
# <small>Usage</small>
#
# ```
# cake test
# ```
task 'test', 'run tests', -> build -> mocha -> log ":)", green


# Internal Functions
#
# ## *walk*
#
# **given** string as dir which represents a directory in relation to local directory
# **and** callback as done in the form of (err, results)
# **then** recurse through directory returning an array of files
#
# Examples
#
# ``` coffeescript
# walk 'src', (err, results) -> console.log results
# ```
walk = (dir, done) ->
  results = []
  fs.readdir dir, (err, list) ->
    return done(err, []) if err
    pending = list.length
    return done(null, results) unless pending
    for name in list
      file = "#{dir}/#{name}"
      try
        stat = fs.statSync file
      catch err
        stat = null
      if stat?.isDirectory()
        walk file, (err, res) ->
          results.push name for name in res
          done(null, results) unless --pending
      else
        results.push file
        done(null, results) unless --pending


# ## *log*
#
# **given** string as a message
# **and** string as a color
# **and** optional string as an explanation
# **then** builds a statement and logs to console.
#
log = (message, color, explanation) -> console.log color + message + reset + ' ' + (explanation or '')


# ## *launch*
#
# **given** string as a cmd
# **and** optional array and option flags
# **and** optional callback
# **then** spawn cmd with options
# **and** pipe to process stdout and stderr respectively
# **and** on child process exit emit callback if set and status is 0
launch = (cmd, options=[], callback) ->
  cmd = which(cmd) if which
  app = spawn cmd, options
  app.stdout.pipe(process.stdout)
  app.stderr.pipe(process.stderr)
  app.on 'exit', (status) -> callback?() if status is 0


# ## *build*
#
# **given** optional boolean as watch
# **and** optional function as callback
# **then** invoke launch passing coffee command
# **and** defaulted options to compile src to lib
build = (watch, callback) ->
  if typeof watch is 'function'
    callback = watch
    watch = false

  options = ['-c', '-b', '-o']
  options = options.concat files
  options.unshift '-w' if watch
  launch 'coffee', options, callback


# ## *mocha*
#
# **given** optional array of option flags
# **and** optional function as callback
# **then** invoke launch passing mocha command
mocha = (options, callback) ->
  #if moduleExists('mocha')
  if typeof options is 'function'
    callback = options
    options = []
  # add coffee directive
  options.push './node_modules/.bin/mocha'
  options.push '--reporter'
  options.push 'spec'

  launch 'node', options, callback


# ## *docco*
#
# **given** optional function as callback
# **then** invoke launch passing docco command
docco = (callback) ->
  #if moduleExists('docco')
  walk 'src', (err, files) -> launch 'docco', files, callback


groc = (callback) ->
  options = []
  options.push 'src/**/*.coffee'
  options.push 'README.md'

  launch 'groc', options, callback
