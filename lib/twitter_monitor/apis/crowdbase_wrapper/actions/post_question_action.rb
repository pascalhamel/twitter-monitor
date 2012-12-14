module TwitterMonitor
  module CrowdbaseWrapper
    class PostQuestionAction < Action
      def perform!
        super
        begin
          topic = Crowdbase::Client.instance.topic(@tweet.hashtags.first.hashtag) if @tweet.hashtags.any?
          cb_question = Crowdbase::Question.new(:title => @tweet.content, :section => topic)
          cb_question.post!

          @tweet.status = Tweet::TweetStatus::DONE
          @tweet.save!

          Twitter.update("@#{@tweet.sender_screen_name} Your question was successfully added to Crowdbase.")
        rescue Crowdbase::APIRequestFailedError => ex
          puts "Unable to post the question: #{ex.message}."
        rescue ActiveRecord::ActiveRecordError => ex
          puts "Unable to update tweet completion status: #{ex.message}"
        end
      end
    end
  end
end