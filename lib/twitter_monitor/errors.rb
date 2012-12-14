module TwitterMonitor
  module Errors
    class UnknownAPIException < ArgumentError; end
    class InvalidTweetObject < ArgumentError; end
    class UnknownTweetSender < StandardError; end
  end
end