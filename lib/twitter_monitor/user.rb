module TwitterMonitor
  class User < ActiveRecord::Base
    attr_accessible
    validates_uniqueness_of :twitter_user_id
  end
end