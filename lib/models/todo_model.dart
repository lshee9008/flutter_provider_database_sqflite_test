class Todo {
  int? id; // String -> int?
  String title;
  bool isDone;

  Todo({this.id, required this.title, this.isDone = false});

  factory Todo.fromMap(Map<String, dynamic> json) =>
      Todo(id: json["id"], title: json["title"], isDone: json["isDone"] == 1);

  Map<String, dynamic> toMap() {
    final map = {"title": title, "isDone": isDone ? 1 : 0};
    if (id != null) map["id"] = id!;
    return map;
  }
}
