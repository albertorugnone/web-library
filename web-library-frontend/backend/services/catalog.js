var fs = require('fs');
var multer  = require('multer')
var express = require('express');
var router = express.Router();


router.get('/v1/catalog', function(req, res, next) {
 res.json(' { "result": "ok"} ');
});