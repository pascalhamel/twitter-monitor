module TwitterMonitor
  module CrowdbaseWrapper
    class Analyzer < TwitterMonitor::Analyzer

      def valid_tweet?(tweet)
        if tweet.is_a?(Twitter::Tweet)
          tweet.in_reply_to_user_id == TwitterMonitor.user_id
        else
          tweet.is_a?(TwitterMonitor::Tweet)
        end
      end

      def create_actions(tweet)
        raise Errors::InvalidTweetObject unless tweet.is_a? TwitterMonitor::Tweet

        actions = []

        if tweet.urls.size > 0
          tweet.urls.each do |url|
            actions << PostLinkAction.new(tweet.id, url.url)
          end
        else
          if tweet.content.end_with?('?')
            actions << PostQuestionAction.new(tweet.id)
          else
            actions << PostNoteAction.new(tweet.id)
          end
        end

        actions
      end
    end
  end
end