module TwitterMonitor
  class Action
    attr_accessor :tweet_id

    def initialize(tweet_id)
      @tweet_id = tweet_id
    end

    def perform!
      # This method is a stub and should be overridden in subclasses.
    end
  end
end