class @NextTrackLoader
  $nowPlayingEl: null
  $artistNameEl: null
  $trackNameEl: null
  $coverEl: null
  player: null
  recommender: null

  constructor: ($nowPlayingEl, $artistNameEl, $trackNameEl, player, recommender) ->
    @$nowPlayingEl = $nowPlayingEl
    @$artistNameEl = $artistNameEl
    @$trackNameEl = $trackNameEl
    @$coverEl = @$nowPlayingEl
    @player = player
    @recommender = recommender

  loadTrackFromArtist: (autoPlay, callback) ->
    $nowPlayingEl = @$nowPlayingEl
    $artistNameEl = @$artistNameEl
    $trackNameEl = @$trackNameEl
    $coverEl = @$coverEl
    player = @player
    artist = @recommender.nextRecommendation()
    $.get '/api/beats_artist_track',
      artist: artist['name'],
      (data) ->
        $nowPlayingEl.prop('href', data['resource'])
        $nowPlayingEl.attr('data-duration', data['duration'])
        $artistNameEl.text(data['artist_name'])
        $trackNameEl.text(data['track_name'])
        $coverEl.css('background-image', "url('#{artist['image']}')")
        player.forceClick() if autoPlay
    .fail( =>
      @loadTrackFromArtist(autoPlay)
    ).done( =>
      callback()
    )
