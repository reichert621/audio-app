angular.module('AudioApp').controller 'TextController', ['$scope', '$http', '$routeParams', '$location', '$upload',
  ($scope, $http, $routeParams, $location, $upload) ->
    $scope.selected = {}

    init = ->
      fetch_book()

    fetch_book = ->
      $http.get("/api/texts/#{$routeParams.id}").success (data) ->
        $scope.book = data.text
        $scope.chapters = data.chapters
        c = set_display_chapter()
        $scope.display_chapter_info(c)

    set_display_chapter = ->
      _.find($scope.chapters, (ch) ->
          ch.id.toString() == $routeParams.chapter_id
      ) or _.find($scope.chapters, (ch) -> ch.rank == 1 )

    $scope.display_chapter_info = (chapter) ->
      $location.search('chapter_id', chapter.id)
      $scope.selected.chapter = chapter
      fetch_chapter_excerpts(chapter)

    fetch_chapter_excerpts = (chapter) ->
      $http.get("/api/chapters/#{chapter.id}/excerpts").success (data) ->
        $scope.excerpts = data
        $scope.all_expanded = false

    $scope.excerpt_preview = (excerpt) ->
      if excerpt.show_all
        excerpt.content
      else
        excerpt.content.split(" ").slice(0, 30).join(" ") + "..."

    $scope.toggle_excerpt = (excerpt) ->
      excerpt.show_all = !excerpt.show_all
      check_if_all_expanded_or_collapsed()

    check_if_all_expanded_or_collapsed = ->
      if _.all($scope.excerpts, (e) -> e.show_all == true )
        $scope.all_expanded = true
      else if _.all($scope.excerpts, (e) -> e.show_all == false )
        $scope.all_expanded = false

    $scope.toggle_all_excerpts = ->
      $scope.all_expanded = !$scope.all_expanded
      _.map($scope.excerpts, (excerpt) -> excerpt.show_all = $scope.all_expanded )

    $scope.is_selected = (chapter) ->
      chapter.id == $scope.selected.chapter.id

    $scope.current_user_is_admin = ->
      App.current_user_id == 1

    $scope.upload_image = ->
      for file in $scope.image_file
        $scope.upload = $upload.upload(
          method: 'PUT'
          url: "api/texts/#{$routeParams.id}"
          data: { text_id: $routeParams.id }
          file: file
        ).success (data) ->
          console.log(data)
        .error (data) ->
          console.log(data)

    init()
  ]