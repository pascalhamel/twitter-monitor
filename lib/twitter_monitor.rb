require File.join(File.dirname(__FILE__), '..', 'config', 'active_record')
require File.join(File.dirname(__FILE__), 'twitter_monitor', 'action')
require File.join(File.dirname(__FILE__), 'twitter_monitor', 'analyzer')
require File.join(File.dirname(__FILE__), 'twitter_monitor', 'errors')
require File.join(File.dirname(__FILE__), 'twitter_monitor', 'tweet')
require File.join(File.dirname(__FILE__), 'twitter_monitor', 'tweet_url')
require File.join(File.dirname(__FILE__), 'twitter_monitor', 'tweet_hashtag')
require File.join(File.dirname(__FILE__), 'twitter_monitor', 'user')
require File.join(File.dirname(__FILE__), 'twitter_monitor', 'apis', 'crowdbase')

module TwitterMonitor
  if File.exists?("#{File.dirname(__FILE__)}/../config/twitter.yml")
    TWITTER_CONFIG = YAML.load_file("#{File.dirname(__FILE__)}/../config/twitter.yml")
  end

  TWITTER_CONFIG ||= {}
  TWITTER_CONFIG['consumer_key'] = ENV['TWITTER_CONSUMER_KEY'] if ENV['TWITTER_CONSUMER_KEY']
  TWITTER_CONFIG['consumer_secret'] = ENV['TWITTER_CONSUMER_SECRET'] if ENV['TWITTER_CONSUMER_SECRET']
  TWITTER_CONFIG['oauth_token'] = ENV['TWITTER_OAUTH_TOKEN'] if ENV['TWITTER_OAUTH_TOKEN']
  TWITTER_CONFIG['oauth_secret'] = ENV['TWITTER_OAUTH_SECRET'] if ENV['TWITTER_OAUTH_SECRET']

  class << self
    attr_accessor :user_id
    attr_reader :api, :analyzer

    CROWDBASE = 'crowdbase'
    SUPPORTED_APIS = [CROWDBASE]

    def configure(api)
      TweetStream.configure do |config|
        config.consumer_key = TWITTER_CONFIG['consumer_key']
        config.consumer_secret = TWITTER_CONFIG['consumer_secret']
        config.oauth_token = TWITTER_CONFIG['oauth_token']
        config.oauth_token_secret = TWITTER_CONFIG['oauth_secret']
        config.auth_method = :oauth
      end

      Twitter.configure do |config|
        config.consumer_key = TWITTER_CONFIG['consumer_key']
        config.consumer_secret = TWITTER_CONFIG['consumer_secret']
        config.oauth_token = TWITTER_CONFIG['oauth_token']
        config.oauth_token_secret = TWITTER_CONFIG['oauth_secret']
      end

      if SUPPORTED_APIS.include?(api.downcase)
        @api = api
      else
        raise Errors::UnknownAPIException.new
      end

      @analyzer = case @api
                    when CROWDBASE
                      CrowdbaseWrapper::Analyzer.new
                    else
                      nil
                  end
    end

  end
end