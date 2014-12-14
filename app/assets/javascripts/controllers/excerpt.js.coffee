angular.module('AudioApp').controller 'ExcerptController', ['$scope', '$http', '$routeParams', '$interval',
  ($scope, $http, $routeParams, $interval) ->
    $scope.num_words = [1, 2, 3, 5, 7, 10]
    $scope.read_speeds = [1000, 700, 500, 300, 200, 100]
    $scope.num_words_per_snippet = $scope.num_words[2]
    $scope.ms_speed = $scope.read_speeds[2]

    init = ->
      fetch_excerpt()

    fetch_excerpt = ->
      $http.get("/api/excerpts/#{$routeParams.id}").success (data) ->
        $scope.excerpt = data.excerpt
        $scope.chapter = data.chapter
        $scope.excerpt_words = $scope.excerpt.content.split(" ")
        $scope.reset_speed_read()

    $scope.reset_speed_read = ->
      $scope.start_word_index = 0
      update_speed_read_snippet()

    $scope.start_speed_read = ->
      $scope.reset_speed_read() if $scope.speed_read_finished
      $scope.is_speed_reading = true
      $scope.stop_read = $interval(show_next_snippet, $scope.ms_speed)

    update_speed_read_snippet = ->
      $scope.speed_read_snippet = 
        $scope.excerpt_words
        .slice($scope.start_word_index, $scope.start_word_index + $scope.num_words_per_snippet)
        .join(" ")

    show_next_snippet = ->
      if ($scope.start_word_index + $scope.num_words_per_snippet) > $scope.excerpt_words.length
        $scope.speed_read_finished = true
        $scope.stop_speed_read()
      else
        $scope.start_word_index += $scope.num_words_per_snippet
        update_speed_read_snippet()

    $scope.stop_speed_read = ->
      $interval.cancel($scope.stop_read)
      $scope.stop_read = undefined
      $scope.is_speed_reading = false

    init()
  ]