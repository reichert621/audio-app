angular.module('AudioApp').controller 'MainController', ['$scope', '$http', '$timeout', 'BookFactory',
  ($scope, $http, $timeout, BookFactory) ->
    init = ->
      fetch_books()

    fetch_books = ->
      BookFactory.fetch_books().then ->
        $scope.books = BookFactory.books

    init()
  ]