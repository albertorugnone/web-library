var Library, LibraryConfiguration, LibraryInit, LibraryRunner;

Library = (function() {
  function Library() {
    return ['ui.router', 'templates', 'library.login', 'library.catalog'];
  }

  return Library;

})();

LibraryRunner = (function() {
  function LibraryRunner() {}

  return LibraryRunner;

})();

LibraryConfiguration = (function() {
  function LibraryConfiguration($stateProvider, $urlRouterProvider, $locationProvider, $httpProvider, $logProvider) {
    $logProvider.debugEnabled(true);
    if (!$httpProvider.defaults.headers.get) {
      $httpProvider.defaults.headers.get = {};
    }
    $httpProvider.defaults.headers.get['If-Modified-Since'] = '0';
    $locationProvider.html5Mode(false);
    $urlRouterProvider.otherwise('/login');
    $stateProvider.state('login', {
      url: '/login',
      views: {
        'template': {
          controller: 'libraryLoginController',
          templateUrl: 'components/login/login.html'
        }
      }
    }).state('catalog', {
      url: '/catalog',
      views: {
        'template': {
          controller: 'libraryCatalogController',
          templateUrl: 'components/catalog/catalog.html'
        }
      }
    });
  }

  return LibraryConfiguration;

})();

LibraryInit = (function() {
  function LibraryInit($log) {
    $log("[LibraryInit] : Library application starting");
  }

  return LibraryInit;

})();

angular.module('library', new Library()).run([LibraryRunner]).config(['$stateProvider', '$urlRouterProvider', '$locationProvider', '$httpProvider', '$logProvider', LibraryConfiguration]).controller('libraryInitController', ['$log', LibraryInit]);

var Catalog, CatalogResources, LibraryCatalog;

Catalog = (function() {
  function Catalog() {
    return ['ui.router'];
  }

  return Catalog;

})();

LibraryCatalog = (function() {
  function LibraryCatalog($log, $scope, CatalogResources) {
    $log.debug('[LibraryCatalog] catalog started');
    $scope.selected_author = void 0;
    CatalogResources.loadAuthors().then(function(resp) {
      $log.debug('[LibraryCatalog] loaded');
      return $scope.authors = resp;
    });
    $log.debug($scope.authors);
    $scope.select = function(author) {
      $scope.selected_author = author;
      return $log.debug('[LibraryCatalog] author selected is ' + author.name);
    };
    $scope.isSelected = function(author) {
      var ref;
      return (author != null ? author.id : void 0) === ((ref = $scope.selected_author) != null ? ref.id : void 0);
    };
  }

  return LibraryCatalog;

})();

CatalogResources = (function() {
  function CatalogResources($log, $http) {
    var factory;
    factory = {
      loadAuthors: function(scope) {
        return $http.get('v1/authors').then(function(resp) {
          return resp.data;
        });
      }
    };
    return factory;
  }

  return CatalogResources;

})();

angular.module('library.catalog', new Catalog()).controller('libraryCatalogController', ['$log', '$scope', 'CatalogResources', LibraryCatalog]).factory('CatalogResources', ['$log', '$http', CatalogResources]);

var LibraryLogin, Login;

Login = (function() {
  function Login() {
    return ['ui.router', 'ui.bootstrap'];
  }

  return Login;

})();

LibraryLogin = (function() {
  function LibraryLogin($scope, $modal, $log, $state) {
    $scope.user = {};
    $scope.login = function() {
      $log.debug('[LibraryLogin] scope user email: ' + $scope.user.email);
      $log.debug('[LibraryLogin] scope user password: ' + $scope.user.password);
      $log.debug('[LibraryLogin] going to catalog');
      $state.go('catalog');
    };
    $scope.openCatalog = function() {
      $log.debug('[LibraryLogin] going to catalog');
      return $state.go(' catalog');
    };
  }

  return LibraryLogin;

})();

angular.module('library.login', new Login()).controller('libraryLoginController', ['$scope', '$modal', '$log', '$state', LibraryLogin]);

//# sourceMappingURL=maps/app.js.map