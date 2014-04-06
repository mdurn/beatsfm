class AddBeatsFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :full_name, :string
    add_column :users, :username, :string
    add_column :users, :beats_token, :string
    add_column :users, :beats_refresh_token, :string
    add_column :users, :beats_expires, :boolean
    add_column :users, :beats_expires_at, :integer
  end
end
