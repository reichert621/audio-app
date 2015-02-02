angular.module('AudioApp').factory 'BookFactory', ($http) ->
  BookFactory = 
    books: []

    fetch_books: ->
      $http.get('/api/texts').success (data) ->
        BookFactory.books = data

  BookFactory