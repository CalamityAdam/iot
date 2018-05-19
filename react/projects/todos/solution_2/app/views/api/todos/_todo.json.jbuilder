json.set! todo.id do 
    json.extract! todo, :id, :user_id, :done, :title 
    json.tags_id todo.tags.pluck(:id)
end 