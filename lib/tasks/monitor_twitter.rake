require 'twitter'
require 'tweetstream'
require File.join(File.dirname(__FILE__), '..', 'twitter_monitor')

desc 'This task is a daemon that fetches all the tweets sent directly to the logged-in account.'

task :monitor_twitter do

  def handle_tweet(tweet)
    # As a future improvement, the content of this method should be moved to an async job and
    # we could use Resque to manage the whole thing.

    if TwitterMonitor.analyzer.valid_tweet?(tweet)

      begin
        tweet = TwitterMonitor::Tweet.from_twitter_gem(tweet)
        actions = TwitterMonitor.analyzer.create_actions(tweet)
        actions.each {|action| action.perform! }
      rescue ActiveRecord::ActiveRecordError
        puts "The tweet #{tweet.id} was already added to our database."
      rescue Exception => e
        puts "Unable to perform action due to an unknown error: #{e.message}"
      end

    end
  end

  api = ENV['api']
  TwitterMonitor.configure(api)

  TwitterMonitor.user_id = begin
    user = Twitter.verify_credentials
    user.id
  rescue Twitter::Error::Unauthorized
    puts "Unable to authenticate to the Twitter API. Please check the Twitter configuration."
    next
  rescue Exception => e
    puts "An error occurred while trying to authenticate to Twitter API: #{e.message}"
    next
  end

  # Before we start streaming in the tweets, we make sure we did not skip any (if our process crashed or whatnot)
  latest_tweet = TwitterMonitor::Tweet.last

  if latest_tweet
    # We fetch the tweets that are more recent for our current user
    tweets = Twitter.mentions_timeline(:count => 200, :since_id => latest_tweet.tweet_id)
    tweets.each do |tweet|
      handle_tweet(tweet)
    end
  end

  TweetStream::Client.new.userstream do |status|
    # User Streams feeds all kinds of events. We only care about tweets.
    handle_tweet(status) if status.text
  end
end