angular.module('AudioApp', [
    'ngRoute',
    'templates'
  ]).config(['$routeProvider',
  function ($routeProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'index.html',
        controller: 'MainController'
      })
      .when('/texts/:id', {
        templateUrl: 'text.html',
        controller: 'TextController'
      })
      .when('/record', {
        templateUrl: 'record.html',
        controller: 'RecordingController'
      });
  }]);