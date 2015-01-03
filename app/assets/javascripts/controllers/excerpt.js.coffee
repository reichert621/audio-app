angular.module('AudioApp').controller 'ExcerptController', ['$scope', '$http', '$routeParams', '$interval', '$location', '$sce',
  ($scope, $http, $routeParams, $interval, $location, $sce) ->
    $scope.num_words = [1, 2, 3, 5, 7, 10]
    $scope.read_speeds = [1000, 700, 500, 300, 200, 100]
    $scope.num_words_per_snippet = $scope.num_words[2]
    $scope.ms_speed = $scope.read_speeds[2]

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

      navigator.getUserMedia({audio: true}, startUserMedia, (e) ->
        console.log 'No live audio input: ' + e
      )

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
          rec.audio.url = $sce.trustAsResourceUrl(rec.audio.url)
        )

    save_recording = (file, name) ->
      params = { name: name, audio: file }
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
        reader = new FileReader()
        reader.onload = (e) ->
          save_recording(e.target.result, name)
        reader.readAsDataURL(blob)

    add_recording_to_list = (recording) ->
      recording.audio.url = $sce.trustAsResourceUrl(recording.audio.url)
      $scope.recordings.push(recording)

    init()
  ]