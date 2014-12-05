angular.module('AudioApp').controller 'MainCtrl', ['$scope', '$http', '$timeout',
  ($scope, $http, $timeout) ->
    $scope.form = {}
    init = ->
      fetch_recordings()

    fetch_recordings = ->
      $http.get('/api/recordings').success (data) ->
        $scope.recordings = data
      .error (data) ->
        # Show default dummy items
        $scope.recordings = [
          { name: "Alex's Recording", url: "http://alexreichert.com" },
          { name: "Random Song", url: "http://example.com" }
        ]

    $scope.create_new_recording = ->
      params = { name: $scope.form.new_name, url: $scope.form.new_url }
      $http.post('/api/recordings', params).success (data) ->
        add_recording_to_list(data)
      .error (data) ->
        flash_error_messages(data)

    add_recording_to_list = (recording) ->
      $scope.recordings.push(recording)
      $scope.form.new_name = ""
      $scope.form.new_url = ""

    flash_error_messages = (errors) ->
      $scope.form.error_messages = errors
      $timeout( (-> $scope.form.error_messages = null), 5000)

    init()
  ]