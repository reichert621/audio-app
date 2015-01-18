angular.module('AudioApp', [
    'ngRoute',
    'templates',
    'ui.bootstrap',
    'angularFileUpload'
  ]).config(['$routeProvider',
  function ($routeProvider) {
    $routeProvider
      .when('/home', {
        templateUrl: 'index.html',
        controller: 'MainController'
      })
      .when('/texts/:id', {
        templateUrl: 'text.html',
        controller: 'TextController',
        reloadOnSearch: false
      })
      .when('/texts/:text_id/chapters/:id', {
        templateUrl: 'chapter.html',
        controller: 'ChapterController'
      })
      .when('/excerpts/:id', {
        templateUrl: 'excerpt.html',
        controller: 'ExcerptController'
      })
      .when('/record', {
        templateUrl: 'record.html',
        controller: 'RecordingController'
      })
      .otherwise({
        redirectTo: '/home'
      });
  }]);