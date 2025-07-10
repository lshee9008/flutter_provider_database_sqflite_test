import 'package:flutter/material.dart';
import 'package:flutter_provider_database_sqflite_test/providers/todo_provider.dart';
import 'package:provider/provider.dart';

import '../models/todo_model.dart';

class EditTodoScreen extends StatelessWidget {
  final Todo todo;

  EditTodoScreen({required this.todo});

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController(
      text: todo.title,
    );

    return Scaffold(
      appBar: AppBar(title: Text('Edit Todo')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final updatedTodo = Todo(
                    id: todo.id,
                    title: titleController.text,
                    isDone: todo.isDone,
                  );
                  Provider.of<TodoProvider>(
                    context,
                    listen: false,
                  ).updateTodo(updatedTodo);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
