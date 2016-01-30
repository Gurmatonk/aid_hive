class AddOmniauthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :oauth_provider, :string
    add_column :users, :oauth_uid, :string
    add_index :users, [:oauth_provider, :oauth_uid], unique: true
  end
end
