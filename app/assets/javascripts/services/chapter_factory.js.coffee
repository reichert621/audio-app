angular.module('AudioApp').factory 'ChapterFactory', ($http) ->
  ChapterFactory = 
    book: null
    chapters: []
    excerpts: []

    fetch_book: (book_id) ->
      $http.get("/api/texts/#{book_id}").success (data) ->
        ChapterFactory.book = data.text
        ChapterFactory.chapters = data.chapters

    fetch_chapter_excerpts: (chapter) ->
      $http.get("/api/chapters/#{chapter.id}/excerpts").success (data) ->
        ChapterFactory.excerpts = data

  ChapterFactory