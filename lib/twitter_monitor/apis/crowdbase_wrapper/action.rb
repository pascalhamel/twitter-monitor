module TwitterMonitor
  module CrowdbaseWrapper
    class Action < TwitterMonitor::Action
      attr_accessor :tweet

      def perform!
        begin
          @tweet = Tweet.find(@tweet_id)
          user = User.find_by_twitter_user_id(@tweet.sender_id)
          raise UnknownTweetSender.new unless user

          Crowdbase::Client.instance = Crowdbase::Client.new
          Crowdbase::Client.instance.access_token = user.crowdbase_access_token
          Crowdbase::Client.instance.refresh_token = user.crowdbase_refresh_token
          Crowdbase::Client.instance.expires_at = user.crowdbase_expiration_date
          Crowdbase::Client.instance.user_id = user.crowdbase_user_id

          if Crowdbase::Client.instance.token_expired?
            #TODO: Refresh token
          end

        rescue ActiveRecord::RecordNotFound
          puts "The tweet with id #{super.tweet_id} was not found to perform an action."
        rescue UnknownTweetSender
          puts "The sender with id #{@tweet.sender_id} and screen name #{@tweet.sender_screen_name} is not known."
        end
      end
    end
  end
end

require File.join(File.dirname(__FILE__), 'actions', 'post_link_action')
require File.join(File.dirname(__FILE__), 'actions', 'post_question_action')
require File.join(File.dirname(__FILE__), 'actions', 'post_note_action')