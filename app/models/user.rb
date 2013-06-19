class User < ActiveRecord::Base
  has_many :tweets
  validates :username, :uniqueness => true

  def tweet(text)
    tweet = self.tweets.create!(text: text)
    TweetWorker.perform_async(tweet.id)
  end
end
