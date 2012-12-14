# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 4) do

  create_table "tweet_hashtags", :force => true do |t|
    t.integer  "tweet_id",   :limit => 8
    t.string   "hashtag"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "tweet_urls", :force => true do |t|
    t.integer  "tweet_id",   :limit => 8
    t.string   "url"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "tweets", :force => true do |t|
    t.integer  "tweet_id",           :limit => 8
    t.integer  "sender_id",          :limit => 8
    t.string   "sender_screen_name"
    t.text     "content"
    t.text     "raw"
    t.string   "status"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "crowdbase_user_id"
    t.integer  "twitter_user_id",           :limit => 8
    t.string   "crowdbase_access_token"
    t.string   "crowdbase_refresh_token"
    t.datetime "crowdbase_expiration_date"
    t.string   "crowdbase_subdomain"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

end
