module TwitterMonitor
  module CrowdbaseWrapper
    class PostLinkAction < Action
      attr_accessor :url

      def initialize(tweet_id, url)
        super(tweet_id)
        @url = url
      end

      def perform!
        super
        begin
          topic = Crowdbase::Client.instance.topic(@tweet.hashtags.first.hashtag) if @tweet.hashtags.any?

          @tweet.urls.each do |link|
            cb_link = Crowdbase::Link.new(:url => link.url, :title => @tweet.content, :description => @tweet.content, :section => topic)
            cb_link.post!
          end

          @tweet.status = Tweet::TweetStatus::DONE
          @tweet.save!

          Twitter.update("@#{@tweet.sender_screen_name} Your link was successfully added to Crowdbase.")
        rescue Crowdbase::APIRequestFailedError => ex
          puts "Unable to post the link: #{ex.message}."
        rescue ActiveRecord::ActiveRecordError => ex
          puts "Unable to update tweet completion status: #{ex.message}"
        end
      end
    end
  end
end