var fs = require('fs');
var express = require('express');
var router = express.Router();


router.get('/v1/authors', function(req, res, next) {
    var authors = [
        {
            "name": "Mario Rossi",
            "age": 39,
            "nickname": "Mr Mario",
            "id": "6"
        }, {
            "name": "Mario Rossi 1",
            "age": 39,
            "nickname": "Mr Mario",
            "id": "7"
        }, {
            "name": "Mario Rossi 2",
            "age": 39,
            "nickname": "Mr Mario",
            "id": "8"
        }, {
            "name": "Mario Rossi 3",
            "age": 39,
            "nickname": "Mr Mario",
            "id": "9"
        }, {
            "name": "Mario Rossi 4",
            "age": 39,
            "nickname": "Mr Mario",
            "id": "10"
        }
    ];

    res.json(authors);
});



module.exports = router;
