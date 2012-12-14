class CreateTweetHashtags < ActiveRecord::Migration
  def self.up
    create_table "tweet_hashtags" do |t|
      t.column :tweet_id, :bigint
      t.string :hashtag

      t.timestamps
    end
  end

  def self.down
    drop_table "tweet_hashtags"
  end
end