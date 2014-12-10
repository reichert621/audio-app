angular.module('AudioApp').controller 'MainCtrl', ['$scope', '$http', '$timeout',
  ($scope, $http, $timeout) ->
    $scope.form = {}
    $scope.can_record = false
    $scope.is_recording = false

    init = ->
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
      handle_audio_file()
      $scope.recorder.clear()

    fetch_recordings = ->
      $http.get('/api/recordings').success (data) ->
        $scope.recordings = data

    save_recording = (file, name) ->
      params = { name: name, audio: file }
      $http.post('/api/recordings', params).success (data) ->
        add_recording_to_list(data)
      .error (data) ->
        flash_error_messages(data)

    handle_audio_file = (blob) ->
      $scope.recorder && $scope.recorder.exportWAV (blob) ->
        name = "#{new Date().toISOString()}.wav"
        reader = new FileReader()
        reader.onload = (e) ->
          save_recording(e.target.result, name)
        reader.readAsDataURL(blob)

    add_recording_to_list = (recording) ->
      $scope.recordings.push(recording)

    flash_error_messages = (errors) ->
      $scope.form.error_messages = errors
      $timeout( (-> $scope.form.error_messages = null), 5000)

    init()
  ]