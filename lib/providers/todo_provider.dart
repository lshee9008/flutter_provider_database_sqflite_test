import 'package:flutter/material.dart';
import 'package:flutter_provider_database_sqflite_test/services/database_helper.dart';

import '../models/todo_model.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  Future<void> loadTodos() async {
    _todos = await DatabaseHelper().getTodos();
    notifyListeners();
  }

  Future<void> addTodo(Todo todo) async {
    await DatabaseHelper().insertTodo(todo);
    await loadTodos();
  }

  Future<void> updateTodo(Todo todo) async {
    await DatabaseHelper().updateTodo(todo);
    await loadTodos();
  }

  Future<void> removeTodo(int id) async {
    await DatabaseHelper().deleteTodo(id);
    await loadTodos();
  }
}
