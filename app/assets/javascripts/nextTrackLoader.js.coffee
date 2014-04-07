class @NextTrackLoader
  $nowPlayingEl: null
  player: null
  recommender: null

  constructor: ($nowPlayingEl, player, recommender) ->
    @$nowPlayingEl = $nowPlayingEl
    @player = player
    @recommender = recommender

  loadTrackFromArtist: (autoPlay) ->
    $nowPlayingEl = @$nowPlayingEl
    player = @player
    $.get '/api/beats_artist_track',
      artist: @recommender.nextRecommendation(),
      (data) ->
        $nowPlayingEl.prop('href', data['resource'])
        $nowPlayingEl.attr('data-duration', data['duration'])
        $nowPlayingEl.text(data['artist_name'] + " - " + data['track_name'])
        player.forceClick() if autoPlay
    .fail( =>
      @loadTrackFromArtist(autoPlay)
    )