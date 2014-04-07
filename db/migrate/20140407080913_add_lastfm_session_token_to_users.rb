class AddLastfmSessionTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lastfm_session_token, :string
  end
end
