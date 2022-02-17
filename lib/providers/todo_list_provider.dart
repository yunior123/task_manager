import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/todo_model.dart';
import '../resources/todos_api.dart';

class TodoProvider with ChangeNotifier {
  final _todosApi = Get.find<TodosApi>();
  late final List<TodoModel> _todoList = [];

  List<TodoModel> get getTodos => _filteredTodoList;

  var _filteredTodoList = <TodoModel>[];

  set setTodos(List<TodoModel> list) {
    _todoList.clear();
    _todoList.addAll(list);
    _todoList.sort(((a, b) => b.datetime.compareTo(a.datetime)));
    _filteredTodoList = _todoList;
  }

  void onFiltered(String? string) {
    if (string != null && string.isNotEmpty) {
      _filteredTodoList = _todoList
          .where(
            (e) => e.title.toLowerCase().trim().contains(
                  string.toLowerCase().trim(),
                ),
          )
          .toList();
    } else {
      _filteredTodoList = _todoList;
    }
    notifyListeners();
  }

  Stream<List<TodoModel>>? requestTodos() {
    final stream = _todosApi.requestTodoModels();
    return stream;
  }

  Future<void> updateTodoStatus(String todoId, String status) async {
    final data = {
      'status': status,
    };
    await _todosApi.fsUpdateOneDocWithId(
      collection: 'todo_list',
      docId: todoId,
      model: data,
    );
  }
}
