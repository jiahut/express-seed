express      = require 'express'
path         = require 'path'
morgan       = require 'morgan'
fs           = require 'fs'
cookieParser = require "cookie-parser"
bodyParser   = require "body-parser"
stylus       = require 'stylus'
nib          = require 'nib'
favicon      = require "serve-favicon"
coffee       = require 'coffee-middleware'

app    = express()
server = require("http").createServer app
io     = require("socket.io").listen server
index  = require('./routes/index')

accessLogStream = fs.createWriteStream __dirname + "/access.log", flags: 'a'

# view setups
app.set 'view', path.join __dirname, 'views'
app.set 'view engine', 'jade'

compile = (str, path)->
  stylus(str)
    .set('filename', path)
    .use(nib())

# uncomment after placing your favicon in /public
#app.use(favicon(__dirname + '/public/favicon.ico'));

app.use express.static path.join(__dirname, '/public')
app.use morgan 'short', stream: accessLogStream
app.use stylus.middleware
  src: path.join(__dirname, "public")
  compile: compile
app.use coffee
  src: path.join(__dirname, 'public')
  compress: true
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: false)
app.use cookieParser()

app.use "/", index

app.use (req, res, next) ->
  err = new Error("Not Found")
  err.status = 404
  next err

app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render "error",
    message: err.message
    error: if app.get("env") is "development" then err else {}

io.on 'connection', (socket) ->
  # (pull = ()->
  #   socket.emit "pull", hello: 'world'
  #   setTimeout pull, 2000
  # )()
  tweets = setInterval ()->
    socket.emit "pull", hello: 'world'
  ,1000

  socket.on 'push', (data)->
    console.log data
  socket.on 'disconnect', ()->
    clearInterval(tweets)
    console.log 'disconnect'

server.listen 8080
