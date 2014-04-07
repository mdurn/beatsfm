class @LastFmRecommender
  recommendations: ['The Pharcyde', 'Mac DeMarco', 'Tame Impala', 'Purity Ring', 'The Sword'] # replaced after load
  index: 0

  constructor: (callback) ->
    $.get '/api/lastfm_recommend_artists',
      (data) =>
        console.log data
        @recommendations = data['artists']
        callback()

  nextRecommendation: ->
    recommendation = @recommendations[@index++]
    @index = 0 if @index >= @recommendations.length
    recommendation