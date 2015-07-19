class Catalog extends App then constructor: -> return ['ui.router']

class LibraryCatalog extends Controller
  constructor: ($log) -> $log.debug '[LibraryCatalog] login started'
