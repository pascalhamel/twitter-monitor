module TwitterMonitor
  class TweetUrl < ActiveRecord::Base
    belongs_to :tweet
    validates_presence_of :url

    attr_accessible :url
  end
end