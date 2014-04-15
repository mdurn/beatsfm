class ApisController < ApplicationController
  before_filter :authenticate_user!

  def beats_artist_track
    return unless beats_extend_authorization

    artist_name = params['artist']
    user = current_user
    access_token = user.beats_token
    client_id = APP_CONFIG[:beats][:api_key]

    artist_resp = HTTParty.get('https://partner.api.beatsmusic.com/v1/api/search/predictive',
      query: {type: 'artist', q: artist_name, client_id: client_id})

    artist = artist_resp['data'].first
    artist_id = artist['id']
    tracks_resp = HTTParty.get("https://partner.api.beatsmusic.com/v1/api/artists/#{artist_id}/tracks",
      query: {order_by: 'popularity', limit: 50, client_id: client_id})

    track = tracks_resp['data'].sample
    track_id = track['id']
    playback_resp = HTTParty.get("https://partner.api.beatsmusic.com/v1/api/tracks/#{track_id}/audio",
      query: {access_token: access_token, acquire: 1})

    render json: {
        artist_name: artist['display'],
        resource: playback_resp['data']['resource'],
        track_name: playback_resp['data']['refs']['track']['display'],
        duration: track['duration'] * 1000
    }
  end

  def beats_extend_authorization
    current_time_i = Time.now.utc.to_i
    time_left = (current_user.beats_expires_at - current_time_i)
    if time_left < 1800
      begin
        resp = HTTParty.post('https://partner.api.beatsmusic.com/v1/oauth2/token', body: {
            client_secret: APP_CONFIG[:beats][:secret],
            client_id: APP_CONFIG[:beats][:api_key],
            refresh_token: current_user.beats_refresh_token,
            grant_type: 'refresh_token' })

        current_user.beats_token = resp['access_token']
        current_user.beats_refresh_token = resp['refresh_token']
        current_user.beats_expires_at = current_time_i + resp['expires_in']
        current_user.save
      rescue
        sign_out(current_user)
        flash[:notice] = 'Session timed out due to inactivity. Sign in again to keep listening.'
        render json: { error: { message: 'session timed out due to inactivity', redirect_url: root_url }}, status: 440
        return false
      end
    end

    true
  end

  def lastfm_recommend_artists
    api_key = APP_CONFIG[:lastfm][:api_key]
    api_secret = APP_CONFIG[:lastfm][:secret]
    sk = current_user.lastfm_session_token
    limit = 100
    lastfm_method = 'user.getRecommendedArtists'
    api_sig_str = "api_key#{api_key}limit#{limit}method#{lastfm_method}sk#{sk}#{api_secret}"
    api_sig = Digest::MD5.hexdigest(api_sig_str.force_encoding(Encoding::UTF_8))

    recommended_resp = HTTParty.post("http://ws.audioscrobbler.com/2.0/?method=#{lastfm_method}", body: {
        api_key: api_key,
        limit: limit,
        sk: sk,
        api_sig: api_sig
    })

    top_resp = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=user.getTopArtists", query: {
        api_key: api_key,
        limit: limit,
        user: current_user.lastfm_username,
        format: 'json'
    })

    recommended_artists = recommended_resp['lfm']['recommendations']['artist'].map {|artist| {name: artist['name'], image: artist['image'].last['__content__']}}
    top_artists = top_resp['topartists']['artist'].map {|artist| {name: artist['name'], image: artist['image'].last['#text']}}

    artists = (recommended_artists + top_artists).shuffle

    render json: { artists: artists }
  end

  def lastfm_scrobble
    api_key = APP_CONFIG[:lastfm][:api_key]
    artist = params['artist_name']
    chosen_by_user = 0
    lastfm_method = 'track.scrobble'
    sk = current_user.lastfm_session_token
    timestamp = Time.now.utc.to_i
    track = params['track_name']
    api_secret = APP_CONFIG[:lastfm][:secret]

    api_sig_str = "api_key#{api_key}artist#{artist}chosenByUser#{chosen_by_user}method#{lastfm_method}" +
        "sk#{sk}timestamp#{timestamp}track#{track}#{api_secret}"
    api_sig = Digest::MD5.hexdigest(api_sig_str.force_encoding(Encoding::UTF_8))

    resp = HTTParty.post("http://ws.audioscrobbler.com/2.0/", body: {
        api_key: api_key,
        artist: artist,
        chosenByUser: chosen_by_user,
        method: lastfm_method,
        sk: sk,
        timestamp: timestamp,
        track: track,
        api_sig: api_sig
    })

    head :ok
  end
end
