class ChangeSentimentResultInTweets < ActiveRecord::Migration
  def change
  	change_column :tweets, :sentiment_result, :integer
  end
end
