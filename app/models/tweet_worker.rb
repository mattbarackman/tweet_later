class TweetWorker
  include Sidekiq::Worker

  sidekiq_options :retry => false

  def perform(tweet_id)
    tweet = Tweet.find(tweet_id)
    user = tweet.user

    twitter_config = YAML.load_file(APP_ROOT.join('config', 'twitter.yml'))
    twitter_config.each do |key, value|
      ENV[key] = value
    end

    Twitter.configure do |config|
      p "*" * 100
      config.consumer_key = ENV['TWITTER_KEY']
      config.consumer_secret = ENV['TWITTER_SECRET']
      config.oauth_token = user.oauth_token
      config.oauth_token_secret = user.oauth_secret
    end


    # sent = "true"
    # begin
    Twitter.update(tweet.text)

    # rescue Exception => e
    #   p e
    #   sent = "false"
    # end
    # sent.to_json
    # set up Twitter OAuth client here
    # actually make API call
    # Note: this does not have access to controller/view helpers
    # You'll have to re-initialize everything inside here

  end
  

end
