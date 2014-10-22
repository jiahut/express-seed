express = require 'express'
morgan  = require 'morgan'
fs      = require 'fs'
app     = express()
server  = require("http").createServer app
io      = require("socket.io").listen server
accessLogStream = fs.createWriteStream __dirname + "/access.log", {flags: 'a'}

app.use express.static __dirname + '/public'
app.use morgan 'combined', stream: accessLogStream

app.get '/', (req, res) ->
  console.log "ok"
  "OK"

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
