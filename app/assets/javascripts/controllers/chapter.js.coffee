angular.module('AudioApp').controller 'ChapterController', ['$scope', '$http', '$routeParams',
  ($scope, $http, $routeParams) ->
    init = ->
      $scope.book_id = $routeParams.text_id
      fetch_chapter()

    fetch_chapter = ->
      $http.get("/api/chapters/#{$routeParams.id}").success (data) ->
        $scope.chapter = data
        fetch_chapter_excerpts(data)

    fetch_chapter_excerpts = (chapter) ->
      $http.get("/api/chapters/#{chapter.id}/excerpts").success (data) ->
        $scope.excerpts = data

    $scope.excerpt_preview = (excerpt) ->
      excerpt.content.split(" ").slice(0, 30).join(" ") + "..."

    init()
  ]