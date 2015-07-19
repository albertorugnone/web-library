class Catalog extends App then constructor: -> return ['ui.router']

class LibraryCatalog extends Controller
  constructor: ($log, $scope) ->
    $log.debug '[LibraryCatalog] catalog started'

    $scope.selected_author = undefined

    $log.debug '[LibraryCatalog] loading authors'

    $scope.authors = [
      { "name": "Mario Rossi",  "age": 39, "nickname":"Mr Mario", "id":"1" }
      { "name": "Mario Rossi 1",  "age": 39, "nickname":"Mr Mario", "id":"2" }
      { "name": "Mario Rossi 2",  "age": 39, "nickname":"Mr Mario", "id":"3" }
      { "name": "Mario Rossi 3",  "age": 39, "nickname":"Mr Mario", "id":"4" }
      { "name": "Mario Rossi 4",  "age": 39, "nickname":"Mr Mario", "id":"5" }
    ]
    $log.debug $scope.authors

    $scope.select = (author) ->
      $scope.selected_author = author
      $log.debug '[LibraryCatalog] author selected is ' + author.name

    $scope.isSelected = (author) -> author?.id == $scope.selected_author?.id
