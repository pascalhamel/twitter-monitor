require 'active_record'
require 'logger'
require 'erb'

env = ENV['RACK_ENV'] || 'development'
db_config = YAML.load(ERB.new(File.read('config/database.yml')).result)
ActiveRecord::Base.logger = Logger.new(STDOUT) if env == 'development'

ActiveRecord::Migration.verbose = true
ActiveRecord::Base.establish_connection db_config[env]
