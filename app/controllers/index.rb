get '/' do
  @user = current_user 
  erb :index
end

get '/sign_in' do
  redirect request_token.authorize_url
end

get '/auth' do
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])

  session.delete(:request_token)

  @user = User.find_or_create_by_username(username: @access_token.params[:screen_name], oauth_token: @access_token.params[:oauth_token], oauth_secret: @access_token.params[:oauth_token_secret])
  session[:user_id] = @user.id
  redirect '/'  
end

post '/' do
  p params
  delay = Chronic.parse(params[:delay])
  job_id = current_user.tweet(params[:tweet], delay)
  job_id
end  

get '/status/:job_id' do |job_id|
  job_is_complete(job_id)
end

get '/sign_out' do
  session.clear
  redirect '/'
end
