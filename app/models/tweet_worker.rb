class TweetWorker
  include Sidekiq::Worker

  sidekiq_options :retry => 1

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

    Twitter.update(tweet.text)

  end
  
  def retries_exhausted
    "failed"
  end
end
