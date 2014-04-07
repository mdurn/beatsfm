class @NextTrackLoader
  $nowPlayingEl: null
  player: null
  recommender: null

  constructor: ($nowPlayingEl, $coverEl, player, recommender) ->
    @$nowPlayingEl = $nowPlayingEl
    @$coverEl = $coverEl
    @player = player
    @recommender = recommender

  loadTrackFromArtist: (autoPlay) ->
    $nowPlayingEl = @$nowPlayingEl
    $coverEl = @$coverEl
    player = @player
    artist = @recommender.nextRecommendation()
    $.get '/api/beats_artist_track',
      artist: artist['name'],
      (data) ->
        $nowPlayingEl.prop('href', data['resource'])
        $nowPlayingEl.attr('data-duration', data['duration'])
        $nowPlayingEl.text(data['artist_name'] + " - " + data['track_name'])
        $coverEl.css('background-image', "url('#{artist['image']}')")
        player.forceClick() if autoPlay
    .fail( =>
      @loadTrackFromArtist(autoPlay)
    )