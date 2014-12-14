class AddSentimentResultAndWotResultToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :sentiment_result, :text
    add_column :tweets, :wot_result, :text
  end
end
