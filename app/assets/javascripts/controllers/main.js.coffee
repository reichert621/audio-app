angular.module('AudioApp').controller 'MainController', ['$scope', '$http', '$timeout',
  ($scope, $http, $timeout) ->
    init = ->
      fetch_books()

    fetch_books = ->
      $http.get('/api/texts').success (data) ->
        $scope.books = data

    init()
  ]