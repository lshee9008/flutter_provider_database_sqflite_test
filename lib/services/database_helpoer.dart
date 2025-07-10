// sqflite 패키지를 import하여 SQLite 데이터베이스를 사용할 수 있게 함
import 'package:sqflite/sqflite.dart';
// path 패키지를 import하여 운영체제에 따라 경로를 쉽게 생성할 수 있게 함
import 'package:path/path.dart';
// Future와 같은 비동기 기능을 위한 Dart 기본 라이브러리
import 'dart:async';
// Todo 모델 클래스 import - DB ↔ 객체 변환 시 사용됨
import '../models/todo_model.dart';

// 싱글톤 패턴으로 DatabaseHelper 클래스 정의
class DatabaseHelper {
  // 내부에서 사용할 유일한 인스턴스 생성
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  // 외부에서 생성자 호출 시 항상 같은 인스턴스를 반환
  factory DatabaseHelper() => _instance;

  // SQLite Database 객체 (nullable로 선언 후 초기화 예정)
  static Database? _database;

  // 외부에서 직접 생성하지 못하도록 내부 생성자(private constructor)
  DatabaseHelper._internal();

  // 외부에서 database 객체에 접근할 때 사용되는 getter
  // 이미 초기화된 경우 반환, 아니면 초기화 진행
  Future<Database> get database async {
    if (_database != null) return _database!; // 이미 생성되어 있으면 바로 반환
    _database = await _initDatabase(); // 없으면 새로 초기화
    return _database!;
  }

  // 데이터베이스 초기화 함수
  // 앱의 로컬 저장소 경로에 todo_database.db 파일을 생성하고 열기
  Future<Database> _initDatabase() async {
    // 디바이스에 적합한 데이터베이스 저장 경로 생성
    String path = join(await getDatabasesPath(), 'todo_database.db');
    // 해당 경로에 데이터베이스 열기(없으면 onCreate를 통해 생성됨)
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // 데이터베이스가 처음 생성될 때 호출되는 함수
  // todos라는 테이블을 생성
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos(
        id INTEGER PRIMARY KEY AUTOINCREMENT, -- 자동 증가되는 ID 필드 (기본키)
        title TEXT,                           -- 할 일의 제목
        isDone INTEGER                        -- 완료 여부 (0 또는 1, bool 대신 정수)
      )
    ''');
  }

  // DB에서 모든 Todo 목록을 가져오는 함수 (SELECT * FROM todos)
  Future<List<Todo>> getTodos() async {
    final db = await database; // DB 인스턴스 확보
    var res = await db.query('todos'); // todos 테이블에서 모든 행 조회
    // 결과가 비어 있지 않으면 각 Map을 Todo 객체로 변환하여 리스트로 반환
    List<Todo> list = res.isNotEmpty
        ? res.map((c) => Todo.fromMap(c)).toList()
        : [];
    return list;
  }

  // 새로운 Todo를 데이터베이스에 추가하는 함수
  Future<int> insertTodo(Todo todo) async {
    final db = await database; // DB 인스턴스 확보
    return await db.insert('todos', todo.toMap()); // toMap()으로 변환 후 삽입
  }

  // 기존 Todo를 수정하는 함수 (id를 기준으로 갱신)
  Future<int> updateTodo(Todo todo) async {
    final db = await database; // DB 인스턴스 확보
    return await db.update(
      'todos', // 대상 테이블
      todo.toMap(), // 수정할 데이터 (Map 형태)
      where: 'id = ?', // 어떤 데이터를 수정할지 조건 지정
      whereArgs: [todo.id], // 조건에 들어갈 실제 값 (id)
    );
  }

  // 특정 Todo를 삭제하는 함수 (id 기준)
  Future<int> deleteTodo(int id) async {
    final db = await database; // DB 인스턴스 확보
    return await db.delete(
      'todos', // 대상 테이블
      where: 'id = ?', // 어떤 데이터를 삭제할지 조건 지정
      whereArgs: [id], // 조건에 들어갈 실제 값
    );
  }
}
