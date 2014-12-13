json.array!(@tweets) do |tweet|
  json.extract! tweet, :id, :identifier, :data
  json.url tweet_url(tweet, format: :json)
end
