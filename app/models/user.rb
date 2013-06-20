class User < ActiveRecord::Base
  has_many :tweets
  validates :username, :uniqueness => true

  def tweet(text, delay)
    tweet = self.tweets.create!(text: text)
    TweetWorker.perform_at(delay, tweet.id)
  end
end
