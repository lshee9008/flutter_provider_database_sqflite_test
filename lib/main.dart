import 'package:flutter/material.dart';
import 'package:flutter_provider_database_sqflite_test/providers/todo_provider.dart';
import 'package:flutter_provider_database_sqflite_test/screens/todo_list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TodoProvider())],
      child: MaterialApp(
        title: 'To-Do App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: TodoListScreen(),
      ),
    );
  }
}
