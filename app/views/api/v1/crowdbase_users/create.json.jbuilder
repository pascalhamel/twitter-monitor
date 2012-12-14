json.user @user, :crowdbase_user_id, :twitter_user_id if @user
json.error flash[:error] if flash[:error]