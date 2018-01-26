export const fetchTodos = () => {
  return $.ajax(
    {method: "GET",
    url: "api/todos/"}
  );
};

export const fetchTodo = (id) => {
  return $.ajax(
    {
      method: "GET",
      url: `api/todo/${id}`
    }
  );
};

export const createTodo = (todo) => {
  return $.ajax({
    method: "POST",
    url: 'api/todos',
    data: todo
  }
);
};

export const deleteTodo = (todo) => {

  return $.ajax({
    method: "DELETE",
    url: `api/todos/${todo.id}`,
  });
};


export const editTodo = (todo) => {

  return $.ajax({
    method: "PATCH",
    url: `api/todos/${todo.id}`,
    data: todo
  });
};
