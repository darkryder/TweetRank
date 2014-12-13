module PowerhouseHelper
	require 'twitter'
	@@client = nil

	def get_twitter_client
		unless @@client
			puts "Creating new client"
			@@client = Twitter::REST::Client.new do |config|
			  config.consumer_key    = "oAGwa5JCZazLoknxuRPAknQkp"
			  config.consumer_secret = "GH9kaL47EKUzNBMNuZgEMddnxVozZRxWKxmAR9ny4e1JQogODf"
			end
		end
		@@client
	end

end
