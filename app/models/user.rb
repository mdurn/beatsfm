class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :omniauthable,
         omniauth_providers: [:beats]


  #################
  # Class Methods #
  #################

  class << self

    def find_for_beats_oauth(auth)
      where(auth.slice(:provider, :uid)).first_or_create do |user|
          user.provider = auth.provider
          user.uid = auth.uid
          user.password = Devise.friendly_token[0,20]
          #user.name = auth.info.name   # assuming the user model has a name
          #user.image = auth.info.image # assuming the user model has an image
      end
    end

  end
end
