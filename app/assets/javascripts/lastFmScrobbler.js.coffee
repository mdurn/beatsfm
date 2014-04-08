class @LastFmScrobbler

  scrobble: (artistName, trackName) ->
    $.get '/api/lastfm_scrobble',
      artist_name: artistName
      track_name: trackName