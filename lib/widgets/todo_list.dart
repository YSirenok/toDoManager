// widgets/todo_list.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';
import 'todo_item.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  final List<Todo> _todos = <Todo>[];
  final TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildTodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(),
        tooltip: 'Add a Todo',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodoList() {
    if (_todos.isEmpty) {
      return const Center(
        child: Text('No todo exists. Please create one and track your work.'),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      children: _todos.map((Todo todo) {
        return TodoItem(
          key: Key(todo.id),
          todo: todo,
          onTodoChanged: _handleTodoChange,
          deleteTodo: _deleteTodo,
          editTodoName: _editTodoName,
        );
      }).toList(),
    );
  }

  void _addToDoItem(String name) {
    final String todoId = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      _todos.add(Todo(id: todoId, name: name, completed: false));
    });
    _saveTodos();
    _textFieldController.clear();
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a todo'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Type your todo'),
            autofocus: true,
          ),
          actions: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _addToDoItem(_textFieldController.text);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.completed = !todo.completed;
    });
    _saveTodos();
  }

  void _deleteTodo(Todo todo) {
    setState(() {
      _todos.removeWhere((element) => element.id == todo.id);
    });
    _saveTodos();
  }

  void _editTodoName(BuildContext context, Todo todo) async {
    final TextEditingController editController =
        TextEditingController(text: todo.name);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Todo'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(hintText: 'Edit your todo'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _editTodoNameCallback(todo, editController.text);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editTodoNameCallback(Todo todo, String newName) {
    if (newName.isNotEmpty) {
      setState(() {
        todo.name = newName;
      });
      _saveTodos();
    }
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> todosJson =
        _todos.map((todo) => json.encode(todo.toJson())).toList();
    prefs.setStringList('todos', todosJson);
  }

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? todosJson = prefs.getStringList('todos');

    if (todosJson != null) {
      setState(() {
        _todos.clear();
        _todos.addAll(
          todosJson.map((todoJson) => Todo.fromJson(json.decode(todoJson))),
        );
      });
    }
  }
}
