class PowerhouseController < ApplicationController
  include PowerhouseHelper

  before_action :set_tweet, only: [:get_tweet_rating_by_api]

  def home
  end

  def results
  	# Getting client and query
  	@query = get_only_qeuery_params[:query]
  	puts "Fetching client"
  	@twitter_client = get_twitter_client
  	puts "Got client"

  	# Getting search results
  	@results  = @twitter_client.search(@query, result_type: "recent", lang: "en").take(50)

  	@results.each do |tweet|
  		temp = Tweet.new({:identifier => tweet.id, :data => tweet.text})
  		if temp.save
  			puts "Saving tweet. ID: #{tweet.id}"
  		else
  			puts "Tweet could not be saved. ID: #{tweet.id}"
  		end
  	end

  end

  def get_specific_query_rating_by_api
  	@query = get_only_qeuery_params[:query]
  	# mHttpMethods = include 'HTTParty'

	puts "query: " + @query

	options = {:data => [{:text => @query}]}
  	@response = HTTParty.post('http://www.sentiment140.com/api/bulkClassifyJson?appid=f.ssat95@gmail.com',
						:body => options.to_json, :headers => { 'Content-Type' => 'application/json' })
  	puts "Response: " + @response.read_body

  end

  def get_tweet_rating_by_api
  	options = {:data => [{:text => @tweet.data}]}

  	@query = params[:query]
  	
  	puts "tweet: " + @tweet.to_json.to_s
  	puts "query: " + @query.to_s
  	
  	unless @query == ''
  		options[:data][0][:query] =  @query
  	end
  	puts "Options: " + options.to_s
  	@response = HTTParty.post('http://www.sentiment140.com/api/bulkClassifyJson?appid=f.ssat95@gmail.com',
						:body => options.to_json, :headers => { 'Content-Type' => 'application/json' })
  	puts "Response: " + @response.read_body
  	@response = JSON.parse @response.read_body
  end

  private
  	def get_only_qeuery_params
  		params.permit(:query)
  	end

  	def set_tweet
	  	@tweet = Tweet.find_by_identifier(params[:id])
  	end
end
