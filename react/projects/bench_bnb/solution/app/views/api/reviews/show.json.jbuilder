json.review do
  json.partial! '/api/reviews/review', review: @review
end

json.author do
  json.extract :id, :username
end

json.average_rating @review.bench.average_rating
