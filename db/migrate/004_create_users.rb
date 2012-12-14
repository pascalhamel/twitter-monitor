class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users" do |t|
      t.string :crowdbase_user_id
      t.column :twitter_user_id, :bigint
      t.string :crowdbase_access_token
      t.string :crowdbase_refresh_token
      t.datetime :crowdbase_expiration_date
      t.string :crowdbase_subdomain

      t.timestamps
    end
  end

  def self.down
    drop_table "users"
  end
end