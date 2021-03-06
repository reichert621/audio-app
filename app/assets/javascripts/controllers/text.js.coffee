angular.module('AudioApp').controller 'TextController', ['$scope', '$http', '$routeParams', '$location', '$upload', 'ChapterFactory',
  ($scope, $http, $routeParams, $location, $upload, ChapterFactory) ->
    init = ->
      fetch_book()

    fetch_book = ->
      book_id = $routeParams.id
      ChapterFactory.fetch_book(book_id).then ->
        $scope.book = ChapterFactory.book
        $scope.chapters = ChapterFactory.chapters
        $scope.chapter = set_display_chapter()
        $scope.display_chapter_info($scope.chapter)

    set_display_chapter = ->
      _.find($scope.chapters, (ch) ->
          ch.id.toString() == $routeParams.chapter_id
      ) or _.find($scope.chapters, (ch) -> ch.rank == 1 )

    $scope.display_chapter_info = (chapter) ->
      return unless chapter
      $location.search('chapter_id', chapter.id)
      fetch_chapter_excerpts(chapter)

    fetch_chapter_excerpts = (chapter) ->
      ChapterFactory.fetch_chapter_excerpts(chapter).then ->
        $scope.excerpts = ChapterFactory.excerpts
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