angular.module('AudioApp').controller 'TextController', ['$scope', '$http', '$routeParams',
  ($scope, $http, $routeParams) ->
    init = ->
      fetch_book()

    fetch_book = ->
      $http.get("/api/texts/#{$routeParams.id}").success (data) ->
        debugger
        $scope.book = data

    init()
  ]