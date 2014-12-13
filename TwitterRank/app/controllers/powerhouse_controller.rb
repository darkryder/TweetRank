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
  	@results  = @twitter_client.search(@query, result_type: "recent", lang: "en").take(10)
  	puts @results
  end

  private
  	def get_only_qeuery_params
  		params.permit(:query)
  	end
end
