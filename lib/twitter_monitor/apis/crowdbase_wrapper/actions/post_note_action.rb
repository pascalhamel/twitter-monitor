module TwitterMonitor
  module CrowdbaseWrapper
    class PostNoteAction < Action
      def perform!
        super
        begin
          topic = Crowdbase::Client.instance.topic(@tweet.hashtags.first.hashtag) if @tweet.hashtags.any?
          cb_note = Crowdbase::Note.new(:title => @tweet.content, :text => "Sent from Twitter", :section => topic)
          cb_note.post!

          @tweet.status = Tweet::TweetStatus::DONE
          @tweet.save!

          Twitter.update("@#{@tweet.sender_screen_name} Your note was successfully added to Crowdbase.")
        rescue Crowdbase::APIRequestFailedError => ex
          puts "Unable to post the note: #{ex.message}."
        rescue ActiveRecord::ActiveRecordError => ex
          puts "Unable to update tweet completion status: #{ex.message}"
        end
      end
    end
  end
end