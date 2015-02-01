angular.module('AudioApp').controller 'ExcerptController', ['$scope', '$http', '$routeParams', '$interval', '$location', '$sce',
  ($scope, $http, $routeParams, $interval, $location, $sce) ->
    $scope.num_words = [1, 2, 3, 5, 7, 10]
    $scope.read_speeds = [1000, 700, 500, 300, 200, 100]
    $scope.num_words_per_snippet = $scope.num_words[2]
    $scope.ms_speed = $scope.read_speeds[2]
    $scope.speed_read_hidden = false

    init = ->
      fetch_excerpt()
      fetch_recordings()
      try
        window.AudioContext = window.AudioContext || window.webkitAudioContext
        navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia
        window.URL = window.URL || window.webkitURL
        $scope.audio_context = new AudioContext
        console.log 'Audio context set up.'
        console.log 'navigator.getUserMedia ' + (if navigator.getUserMedia then 'available.' else 'not present!')
      catch error
        alert 'No web audio support in this browser!'

      if navigator.getUserMedia
        navigator.getUserMedia({audio: true}, startUserMedia, (e) ->
          console.log 'No live audio input: ' + e
        )

    $scope.user_is_signed_in = ->
      App.current_user_id > 0

    fetch_excerpt = ->
      $http.get("/api/excerpts/#{$routeParams.id}").success (data) ->
        $scope.excerpt = data
        $scope.excerpt_words = $scope.excerpt.content.split(" ")
        $scope.reset_speed_read()

    $scope.current_user_favorite = ->
      _.find($scope.excerpt?.likes, (like) -> like.user_id == App.current_user_id)

    $scope.is_favorited_by_current_user = ->
      if $scope.current_user_favorite()
        'glyphicon-star'
      else
        'glyphicon-star-empty'

    $scope.toggle_favorite = ->
      favorite = $scope.current_user_favorite()
      if favorite
        favorite_excerpt(favorite)
      else
        unfavorite_excerpt()

    favorite_excerpt = (favorite) ->
      $http.delete("/api/favorites/#{favorite.id}").success (data) ->
        $scope.excerpt.likes = _.reject($scope.excerpt.likes, data)
      .error (data) ->
        console.log(data)

    unfavorite_excerpt = ->
      params = favorite: {
        favoritable_id: $scope.excerpt.id,
        favoritable_type: "Excerpt"
      }
      $http.post("/api/favorites/", params).success (data) ->
        $scope.excerpt.likes.push(data)
      .error (data) ->
        console.log(data)

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

    $scope.toggle_show_speed_read = ->
      $scope.speed_read_hidden = !$scope.speed_read_hidden

    startUserMedia = (stream) ->
      input = $scope.audio_context.createMediaStreamSource(stream)
      $scope.recorder = new Recorder(input)
      console.log "Recorder initialized"
      $scope.can_record = true

    $scope.start_recording = ->
      $scope.recorder && $scope.recorder.record()
      $scope.is_recording = true

    $scope.stop_recording = ->
      $scope.recorder && $scope.recorder.stop()
      $scope.is_recording = false
      $scope.can_save_recording = true
      render_audio_preview()

    $scope.reset_recording = ->
      $scope.recorder.clear()
      reset_audio_preview()
      $scope.can_save_recording = false

    reset_audio_preview = ->
      $('.preview-audio audio').attr('src', "")

    $scope.export_audio = ->
      handle_audio_file()
      $scope.recorder.clear()

    render_audio_preview = ->
      $scope.recorder && $scope.recorder.exportWAV (blob) ->
        url = URL.createObjectURL(blob)
        secure_url = $sce.trustAsResourceUrl(url)
        $('.preview-audio audio').attr('src', secure_url)

    fetch_recordings = ->
      $http.get("/api/excerpts/#{$routeParams.id}/recordings").success (data) ->
        $scope.recordings = data
        _.each($scope.recordings, (rec) ->
          rec.audio_url = $sce.trustAsResourceUrl(rec.audio_url)
          rec.url = $sce.trustAsResourceUrl(rec.url)
        )

    save_recording = (file, name, url) ->
      params = { name: name, audio: file, url: url }
      $scope.saving = true
      $http.post("/api/excerpts/#{$routeParams.id}/recordings", params).success (data) ->
        add_recording_to_list(data)
        reset_audio_preview()
        $scope.saving = false
      .error (data) ->
        console.log(data)
        reset_audio_preview()
        $scope.saving = false

    handle_audio_file = ->
      $scope.recorder && $scope.recorder.exportWAV (blob) ->
        name = "#{new Date().toISOString()}.wav"
        url = URL.createObjectURL(blob)
        reader = new FileReader()
        reader.onload = (e) ->
          save_recording(e.target.result, name, url)
        reader.readAsDataURL(blob)

    add_recording_to_list = (recording) ->
      recording.audio_url = $sce.trustAsResourceUrl(recording.url)
      $scope.recordings.push(recording)

    $scope.add_new_comment = (recording) ->
      recording.new_comment = {
        commentable_type: "Recording",
        commentable_id: recording.id
      }

    $scope.cancel_new_comment = (recording) ->
      recording.new_comment = undefined

    $scope.save_new_comment = (recording) ->
      params = comment: recording.new_comment
      $http.post("/api/comments", params).success (data) ->
        recording.comments.push(data)
        recording.new_comment = undefined
      .error (data) ->
        recording.new_comment = undefined
        console.log(data)

    init()
  ]