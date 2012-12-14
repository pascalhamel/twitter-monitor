module TwitterMonitor
  class Tweet < ActiveRecord::Base
    has_many :urls, :class_name => 'TwitterMonitor::TweetUrl'
    has_many :hashtags, :class_name => 'TwitterMonitor::TweetHashtag'
    validates_uniqueness_of :tweet_id, :allow_blank => false
    validates_presence_of :tweet_id, :sender_id, :raw, :status

    attr_accessible :tweet_id, :sender_id, :sender_screen_name, :raw, :content, :status

    class TweetStatus
      VALUES = %w(NEW DONE)
      VALUES.each do |value|
        self.const_set(value.to_sym, value)
      end
    end

    class << self
      def from_twitter_gem(tweet_from_gem)
        raise Errors::InvalidTweetObject.new unless tweet_from_gem.is_a?(Twitter::Tweet)

        tweet = Tweet.new(:tweet_id => tweet_from_gem.id,
                             :sender_id => tweet_from_gem.user.id,
                             :sender_screen_name => tweet_from_gem.user.screen_name,
                             :raw => tweet_from_gem.text.dup,
                             :content => tweet_from_gem.text.dup,
                             :status => TweetStatus::NEW)

        tweet_from_gem.urls.each do |url|
          tweet.content.sub!(url.url, '')
          tweet.urls << TweetUrl.new(:url => url.expanded_url)
        end

        tweet_from_gem.hashtags.each do |hashtag|
          tweet.content.sub!("##{hashtag.text}", '')
          tweet.hashtags << TweetHashtag.new(:hashtag => hashtag.text)
        end

        tweet.content.sub!("@#{tweet_from_gem.in_reply_to_screen_name}", '').strip!.gsub!(/\s+/, ' ')
        tweet.save!
        tweet
      end
    end
  end
end