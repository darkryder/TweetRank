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

  def get_old_results
  	@tweets = Tweet.all
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
  	
  	if !@tweet.sentiment_result
  		puts "Getting sentiment140 result"
	  	unless @query == ''
	  		options[:data][0][:query] =  @query
	  	end
	  	puts "Options: " + options.to_s
	  	@response_140 = HTTParty.post('http://www.sentiment140.com/api/bulkClassifyJson?appid=f.ssat95@gmail.com',
							:body => options.to_json, :headers => { 'Content-Type' => 'application/json' })
	  	puts "Response: " + @response_140.read_body

	  	temp = JSON.parse(@response_140.read_body)["data"][0]["polarity"].to_i
	  	@tweet.sentiment_result = temp
	  	@tweet.save
	end

	@response_140 = @tweet.sentiment_result

	if !@tweet.wot_result
		puts "Getting WOT result"
	  	@response_wot = nil
	  	sites = ""
	  	temp = URI.extract(@tweet.data, ['http', 'https'])
	  	if temp
	  		temp.each do |a|

	  			if a.include? "://t.co/"

	  				t = HTTParty.get("http://expandurl.appspot.com/expand?url=#{CGI::escapeHTML(a)}")
	  				a = JSON.parse(t.read_body)["end_url"]
	  				
	  				# t = HTTParty.get(a)
	  				# a = t.request.last_uri.to_s
	  			end

	  			a = URI.join(a, "/").to_s

	  			sites += a  			
	  			if a[-1, 1] != '/'
		  			sites += '/'
		  		end
			end
	  	end
	  	puts "Sites: " + sites

	  	if sites
	  		key = wot_key
	  		# debugger
	  		@response_wot = HTTParty.get("http://api.mywot.com/0.4/public_link_json2?hosts=#{sites}&key=#{key}")
	  		@tweet.wot_result = @response_wot.read_body
	  		@tweet.save
	  	end
	end
  	@response_wot = JSON.parse @tweet.wot_result
  end

  private
  	def get_only_qeuery_params
  		params.permit(:query)
  	end

  	def set_tweet
	  	@tweet = Tweet.find_by_identifier(params[:id])
  	end
end
