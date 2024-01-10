
class Todo {
  final String id;
  String name;
  bool completed;

  Todo({required this.id, required this.name, required this.completed});

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'completed': completed};
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      name: json['name'],
      completed: json['completed'],
    );
  }
}
