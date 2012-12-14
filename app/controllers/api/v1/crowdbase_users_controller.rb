require 'twitter_monitor'

class Api::V1::CrowdbaseUsersController < ApplicationController
  def create
    begin
      raise ArgumentError unless params[:twitter_user_id] && params[:username] && params[:password] && params[:subdomain]

      config_file_path = File.join(Rails.root, 'lib', 'twitter_monitor', 'apis', 'crowdbase_wrapper', 'config', 'config.yml')

      if File.exists?(config_file_path)
        Crowdbase::Client.from_yml_config!(config_file_path)
      else
        Crowdbase::Client.instance = Crowdbase::Client.new
      end

      Crowdbase::Client.instance.client_id = ENV['CROWDBASE_CLIENT_ID'] if ENV['CROWDBASE_CLIENT_ID']
      Crowdbase::Client.instance.client_secret = ENV['CROWDBASE_CLIENT_SECRET'] if ENV['CROWDBASE_CLIENT_SECRET']
      Crowdbase::Client.instance.subdomain = params[:subdomain]
      Crowdbase::Client.instance.authorize!(:username => params[:username], :password => params[:password])

      raise Exception.new(:message => "Impossible to register user to Crowdbase.") unless Crowdbase::Client.instance.user_id && Crowdbase::Client.instance.access_token

      @user = TwitterMonitor::User.new
      @user.twitter_user_id = params[:twitter_user_id]
      @user.crowdbase_user_id = Crowdbase::Client.instance.user_id
      @user.crowdbase_access_token = Crowdbase::Client.instance.access_token
      @user.crowdbase_refresh_token = Crowdbase::Client.instance.refresh_token
      @user.crowdbase_expiration_date = Crowdbase::Client.instance.expires_at
      @user.crowdbase_subdomain = params[:subdomain]
      @user.save!
    rescue Exception => e
      flash.now[:error] = e.message
      puts "Unable to create user: #{e.message}"
    end
  end
end