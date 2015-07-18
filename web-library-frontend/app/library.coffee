class Library extends App then constructor: -> return [
  'ui.router'
  'templates'
]

class LibraryRunner extends Run
  constructor: () ->

class LibraryConfiguration extends Config
  constructor: (
    $stateProvider,
    $urlRouterProvider,
    $locationProvider,
    $httpProvider,
    $logProvider) ->

    $logProvider.debugEnabled(true)

#interceptor disabled for simplicity
#    $httpProvider.interceptors.push('HTTPErrorsFactory')

    # Disable caching for IE
    $httpProvider.defaults.headers.get = {} unless $httpProvider.defaults.headers.get
    $httpProvider.defaults.headers.get['If-Modified-Since'] = '0'

    $locationProvider
      .html5Mode off

    $urlRouterProvider
      .otherwise '/login'

    $stateProvider
      .state 'login',
        url: '/login'
        views:
          'template':
            templateUrl: 'components/login/login.html'

      .state 'catalog',
        url: '/catalog'
        views:
          'template':
            templateUrl: 'components/catalog/catalog.html'


class LibraryLiInit extends Controller
  constructor: () ->
    alert "it works"

# Util factory
class LibraryFactory extends Factory then constructor: ($log) ->
  factory = {}
  return factory

