module PowerhouseHelper
	require 'twitter'
	@@client = nil

	def get_twitter_client
		unless @@client
			puts "Creating new client"
			@@client = Twitter::REST::Client.new do |config|
			  config.consumer_key    = ENV['twitter_consumer_key']
			  config.consumer_secret = ENV['twitter_consumer_secret']
			end
		end
		@@client
	end

end
