angular.module('AudioApp', [
    'ngRoute',
    'templates'
  ]).config(['$routeProvider',
  function ($routeProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'index.html',
        controller: 'MainCtrl'
      });
  }]);