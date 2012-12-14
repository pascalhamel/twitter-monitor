class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table "tweets" do |t|
      t.column :tweet_id, :bigint
      t.column   :sender_id, :bigint
      t.string :sender_screen_name
      t.text :content
      t.text :raw
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table "tweets"
  end
end
