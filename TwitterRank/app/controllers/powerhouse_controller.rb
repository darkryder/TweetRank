class PowerhouseController < ApplicationController
  include PowerhouseHelper
 
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
  end

  def get_specific_query_rating_by_api
  	@query = get_only_qeuery_params[:query]
  	# mHttpMethods = include 'HTTParty'

	options = {:data => [{:text => @query}]}
  	response = HTTParty.post('http://www.sentiment140.com/api/bulkClassifyJson?appid=f.ssat95@gmail.com',
						:body => options, :headers => { 'Content-Type' => 'application/json' })
  	puts response
  end

  private
  	def get_only_qeuery_params
  		params.permit(:query)
  	end
end
