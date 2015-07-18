class Login extends App then constructor: -> return ['ui.router']


class LibraryLogin extends Controller
  constructor: ($scope, $log, $rootScope, $state) ->
    $scope.defaultDateTo = moment.utc(new Date()).toDate()
    $scope.defaultDateTo.setDate($scope.defaultDateTo.getDate()+1)
    $scope.defaultDateFrom = moment.utc(new Date()).toDate()
    $scope.defaultDateFrom.setDate($scope.defaultDateTo.getDate()-6)
    $scope.defaultType = ''
