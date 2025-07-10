import 'package:flutter/material.dart';
import 'package:flutter_provider_database_sqflite_test/providers/todo_provider.dart';
import 'package:flutter_provider_database_sqflite_test/screens/edit_todo_screen.dart';
import 'package:provider/provider.dart';

import '../models/todo_model.dart';

class TodoListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('To-Do List')),
      body: FutureBuilder(
        future: Provider.of<TodoProvider>(context, listen: false).loadTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return Consumer<TodoProvider>(
            builder: (context, todoProvider, child) {
              return ListView.builder(
                itemCount: todoProvider.todos.length,
                itemBuilder: (ctx, i) => ListTile(
                  title: Text(todoProvider.todos[i].title),
                  trailing: Checkbox(
                    value: todoProvider.todos[i].isDone,
                    onChanged: (_) {
                      todoProvider.updateTodo(
                        Todo(
                          id: todoProvider.todos[i].id,
                          title: todoProvider.todos[i].title,
                          isDone: !todoProvider.todos[i].isDone,
                        ),
                      );
                    },
                  ),
                  onLongPress: () {
                    todoProvider.removeTodo(todoProvider.todos[i].id! as int);
                  },
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            EditTodoScreen(todo: todoProvider.todos[i]),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) {
              TextEditingController controller = TextEditingController();
              return AlertDialog(
                title: Text('Add Todo'),
                content: TextField(
                  controller: controller,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        final newTodo = Todo(title: controller.text); // id 생략

                        Provider.of<TodoProvider>(
                          context,
                          listen: false,
                        ).addTodo(newTodo);
                        Navigator.of(ctx).pop();
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
