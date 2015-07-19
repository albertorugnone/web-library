var fs = require('fs');
var express = require('express');
var router = express.Router();


router.get('/v1/login', function(req, res, next) {
 res.json(' { "result": "ok"} ');
});

module.exports = router;