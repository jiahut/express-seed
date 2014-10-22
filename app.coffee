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

io.sockets.on 'connection', (socket) ->
  (pull = ()->
    socket.emit "pull", hello: 'world'
    setTimeout pull, 2000
  )()
  socket.on 'push', (data)->
    console.log data

server.listen 8080
