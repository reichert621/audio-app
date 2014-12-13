angular.module('AudioApp', [
    'ngRoute',
    'templates'
  ]).config(['$routeProvider',
  function ($routeProvider) {
    $routeProvider
      .when('/home', {
        templateUrl: 'index.html',
        controller: 'MainController'
      })
      .when('/texts/:id', {
        templateUrl: 'text.html',
        controller: 'TextController'
      })
      .when('/texts/:text_id/chapters/:id', {
        templateUrl: 'chapter.html',
        controller: 'ChapterController'
      })
      .when('/record', {
        templateUrl: 'record.html',
        controller: 'RecordingController'
      })
      .otherwise({
        redirectTo: '/home'
      });
  }]);