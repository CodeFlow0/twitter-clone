json.array!(@tweets) do |tweet|
  json.id tweet.id
  json.message tweet.message
  json.created_at tweet.created_at
  json.updated_at tweet.updated_at
  json.user do
    json.id tweet.user.id
    json.username tweet.user.username
    json.email tweet.user.email
    json.created_at tweet.user.created_at
    json.updated_at tweet.user.updated_at
  end
end