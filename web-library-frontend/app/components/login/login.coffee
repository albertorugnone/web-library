class Login extends App then constructor: -> return ['ui.router', 'ui.bootstrap']

class LibraryLogin extends Controller
  constructor: ($scope, $modal, $log, $state) ->
    $scope.user = {}

    $scope.login = () ->
      $log.debug '[LibraryLogin] scope user email: ' + $scope.user.email
      $log.debug '[LibraryLogin] scope user password: ' + $scope.user.password

#      $modal.open
#        animation: true
#        templateUrl: 'components/login/welcome.html'
#        controller: 'libraryLoginController'
#        resolve: {
#          user: () ->
#            $log.debug '[LibraryLogin.Modal] user ' + $scope.user.email
#            return $scope.user
#        }#

#      return
      $log.debug '[LibraryLogin] going to catalog'
      $state.go 'catalog'
      return

    $scope.openCatalog = () ->
      $log.debug '[LibraryLogin] going to catalog'
      $state.go ' catalog'