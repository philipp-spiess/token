express   = require 'express'
everyauth = require './lib/github'
auth      = require './lib/auth'

app = express.createServer()

# Config
app.configure ->
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.session
    secret: 'asdf'
  app.use everyauth.middleware()
  app.use express.methodOverride()
  app.use app.router
  everyauth.helpExpress app

app.configure 'development', ->
  app.use express.errorHandler
    dumpExceptions: true
    showStack: true

app.configure 'production', ->
  app.use express.errorHandler()

app.get '/', (req, res) ->
  auth req, res, (user) ->
    res.json
      login: user.login
      token: user.token

app.listen process.env.PORT ?= 3000, ->
  console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env

module.export = app
