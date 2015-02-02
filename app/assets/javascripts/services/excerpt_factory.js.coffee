angular.module('AudioApp').factory 'ExcerptFactory', ($http) ->
  ExcerptFactory = 
    excerpt: null

    fetch_excerpt: (excerpt_id) ->
      $http.get("/api/excerpts/#{excerpt_id}").success (data) ->
        ExcerptFactory.excerpt = data

    favorite_excerpt: (params) ->
      $http.post("/api/favorites/", params).success (data) ->
        ExcerptFactory.excerpt.likes.push(data)
      .error (data) ->
        console.log(data)

    unfavorite_excerpt: (favorite) ->
      $http.delete("/api/favorites/#{favorite.id}").success (data) ->
        ExcerptFactory.excerpt.likes = _.reject(ExcerptFactory.excerpt.likes, data)
      .error (data) ->
        console.log(data)

  ExcerptFactory