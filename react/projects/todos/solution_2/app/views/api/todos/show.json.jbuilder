json.todo do
  json.partial! 'api/todos/todo', todo: @todo
end