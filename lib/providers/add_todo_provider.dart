import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/todo_model.dart';
import '../resources/todos_api.dart';
import '../widgets/flushbar.dart';

class AddTodoProvider with ChangeNotifier {
  final _todosApi = Get.find<TodosApi>();
  late String _title;
  late String _description;
  late String _type;
  late String _author;
  late String _project;

  void title(String value) {
    _title = value;
  }

  void description(String value) {
    _description = value;
  }

  void type(String value) {
    _type = value;
  }

  void author(String value) {
    _author = value;
  }

  void project(String value) {
    _project = value;
  }

  Future<void> saveTodo(BuildContext context) async {
    final todo = TodoModel(
      docId: '_',
      description: _description,
      title: _title,
      type: _type,
      datetime: DateTime.now(),
      author: _author,
      project: _project,
      status: 'Open',
    );
    await _createTodo(
      context,
      todo,
    );
  }

  Future<void> _createTodo(
    BuildContext context,
    TodoModel todoModel,
  ) async {
    final docId = await _todosApi.fsAddDoc(
      collection: 'todo_list',
      model: todoModel.toMap(),
    );
    final success = docId.isNotEmpty;
    if (success) {
      showFlushBar(
        context: context,
        text: 'Todo added successfully',
        style: FlushBarStyle.success,
      );
    } else {
      showFlushBar(
        context: context,
        text: 'Error creating todo',
        style: FlushBarStyle.error,
      );
    }
  }
}
