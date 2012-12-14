module TwitterMonitor
  class TweetHashtag < ActiveRecord::Base
    belongs_to :tweet
    validates_presence_of :hashtag

    attr_accessible :hashtag
  end
end