class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :omniauthable,
         omniauth_providers: [:beats, :lastfm]


  ####################
  # Instance Methods #
  ####################

  def set_lastfm_credentials!(username, session_token)
    self.lastfm_username = username
    self.lastfm_session_token = session_token
    save
  end

  #################
  # Class Methods #
  #################

  class << self

    def find_for_beats_oauth(auth)
      user = where(auth.slice(:provider, :uid)).first_or_create do |user|
          user.provider = auth.provider
          user.uid = auth.uid
          user.password = Devise.friendly_token[0,20]
          user.full_name = auth.extra.user_data.full_name
          user.username = auth.extra.user_data.username
      end


      user.beats_token = auth.credentials.token
      user.beats_refresh_token = auth.credentials.refresh_token
      user.beats_expires = auth.credentials.expires
      user.beats_expires_at = auth.credentials.expires_at
      user.save

      user
    end

  end
end
