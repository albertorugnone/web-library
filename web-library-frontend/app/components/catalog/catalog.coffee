class Catalog extends App then constructor: -> return ['ui.router']

class LibraryCatalog extends Controller
  constructor: ($log, $scope, CatalogResources) ->
    $log.debug '[LibraryCatalog] catalog started'

    $scope.selected_author = undefined

   # $log.debug '[LibraryCatalog] loading authors'#

#    $scope.authors = [
#      { "name": "Mario Rossi",  "age": 39, "nickname":"Mr Mario", "id":"1" }
#      { "name": "Mario Rossi 1",  "age": 39, "nickname":"Mr Mario", "id":"2" }
#      { "name": "Mario Rossi 2",  "age": 39, "nickname":"Mr Mario", "id":"3" }
#      { "name": "Mario Rossi 3",  "age": 39, "nickname":"Mr Mario", "id":"4" }
#      { "name": "Mario Rossi 4",  "age": 39, "nickname":"Mr Mario", "id":"5" }
#    ]

    CatalogResources.loadAuthors().then (resp) ->
      $log.debug '[LibraryCatalog] loaded'
      $scope.authors = resp

    $log.debug $scope.authors

    $scope.select = (author) ->
      $scope.selected_author = author
      $log.debug '[LibraryCatalog] author selected is ' + author.name

    $scope.isSelected = (author) -> author?.id == $scope.selected_author?.id


# Util factory
class CatalogResources extends Factory then constructor: ($log, $http) ->
  factory = {
    loadAuthors: (scope) ->
      $http.get('/v1/authors').then (resp) ->
        resp.data
  }

  return factory
