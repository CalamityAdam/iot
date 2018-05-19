json.todos do 
    @todos.each do |todo|
        json.partial! 'api/todos/todo', todo: todo
    end
end 

json.tags do
    tags_arr = []
    @todos.each { |todo| tags_arr += todo.tags }

    tags_arr.each do |tag|
        json.set! tag.id do 
            json.extract! tag, :id, :name
        end 
    end 
    
end