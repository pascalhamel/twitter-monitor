class CreateTweetUrls < ActiveRecord::Migration
  def self.up
    create_table "tweet_urls" do |t|
      t.column :tweet_id, :bigint
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table "tweet_urls"
  end
end