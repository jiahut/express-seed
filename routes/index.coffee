router = require('express').Router()

router.get '/', (req, res)->
  res.render 'index',
    title: "index"

router.get '/hello', (req, res)->
  res.render 'hello'

module.exports = router
