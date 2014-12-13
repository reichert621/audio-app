angular.module('AudioApp').controller 'TextController', ['$scope', '$http', '$routeParams',
  ($scope, $http, $routeParams) ->
    init = ->
      fetch_book()

    fetch_book = ->
      $http.get("/api/texts/#{$routeParams.id}").success (data) ->
        $scope.book = data
        fetch_book_chapters(data)

    fetch_book_chapters = (book) ->
      $http.get("/api/texts/#{book.id}/chapters").success (data) ->
        $scope.chapters = data

    init()
  ]