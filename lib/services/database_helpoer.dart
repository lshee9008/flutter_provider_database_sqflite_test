import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import '../models/todo_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'todo_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        isDone INTEGER
      )
    ''');
  }

  Future<List<Todo>> getTodos() async {
    final db = await database;
    var res = await db.query('todos');
    List<Todo> list = res.isNotEmpty
        ? res.map((c) => Todo.fromMap(c)).toList()
        : [];
    return list;
  }

  Future<int> insertTodo(Todo todo) async {
    final db = await database;
    return await db.insert('todos', todo.toMap());
  }

  Future<int> updateTodo(Todo todo) async {
    final db = await database;
    return await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> deleteTodo(int id) async {
    final db = await database;
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}
