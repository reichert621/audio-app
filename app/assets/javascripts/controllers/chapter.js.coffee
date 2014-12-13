angular.module('AudioApp').controller 'ChapterController', ['$scope', '$http', '$routeParams',
  ($scope, $http, $routeParams) ->
    init = ->
      fetch_chapter()

    fetch_chapter = ->
      $http.get("/api/chapters/#{$routeParams.id}").success (data) ->
        $scope.chapter = data
        fetch_chapter_excerpts(data)

    fetch_chapter_excerpts = (chapter) ->
      $http.get("/api/chapters/#{chapter.id}/excerpts").success (data) ->
        $scope.excerpts = data

    init()
  ]