class @Hitplay

  constructor: ($artistNameEl, $trackNameEl, $nextTrackBlockerEl, $nowPlayingEl, $nextTrackBtn, $scrobblerEl, threeSixtyPlayer) ->
    nextTrackLoader = null
    nextTrackCallback = (->
      $nextTrackBlockerEl.hide())

    lastFmRecommender = new window.LastFmRecommender( =>
      nextTrackLoader = new window.NextTrackLoader(
        $nowPlayingEl, $artistNameEl, $trackNameEl, threeSixtyPlayer, lastFmRecommender)
      nextTrackLoader.loadTrackFromArtist(false, nextTrackCallback))

    lastFmScrobbler = new window.LastFmScrobbler()

    $nextTrackBtn.on 'click', =>
      $nextTrackBlockerEl.show();
      nextTrackLoader.loadTrackFromArtist(true, nextTrackCallback)

    $scrobblerEl.on 'scrobble', =>
      lastFmScrobbler.scrobble($artistNameEl.text(), $trackNameEl.text());