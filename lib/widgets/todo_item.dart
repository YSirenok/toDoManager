import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    super.key,
    required this.todo,
    required this.onTodoChanged,
    required this.deleteTodo,
    required this.editTodoName,
  });

  final Todo todo;
  final void Function(Todo todo) onTodoChanged;
  final void Function(Todo todo) deleteTodo;
  final void Function(BuildContext context, Todo todo) editTodoName;

  TextStyle? _getTextStyle(bool checked) {
    return checked
        ? const TextStyle(
            color: Colors.black54,
            decoration: TextDecoration.lineThrough,
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTodoChanged(todo),
      leading: Checkbox(
        checkColor: Colors.white,
        activeColor: Colors.blueAccent,
        value: todo.completed,
        onChanged: (value) => onTodoChanged(todo),
      ),
      title: Expanded(
        child: Text(todo.name, style: _getTextStyle(todo.completed)),
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (String choice) {
          if (choice == 'edit') {
            editTodoName(context, todo);
          } else if (choice == 'delete') {
            deleteTodo(todo);
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'edit',
            child: ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit'),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'delete',
            child: ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
            ),
          ),
        ],
      ),
    );
  }
}
