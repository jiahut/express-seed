router = require('express').Router()

router.get '/', (req, res)->
  res.render 'index',
    title: "index"

module.exports = router
