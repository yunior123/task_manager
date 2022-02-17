import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:task_manager/resources/todos_api_mock.dart';

import '../models/todo_model.dart';

class TodosApi {
  // singleton
  static final TodosApi _singleton = TodosApi._internal();
  factory TodosApi({
    http.Client? client,
    mock = false,
  }) {
    if (mock) {
      return TodosApiMock();
    }
    return _singleton;
  }
  TodosApi._internal();

  Stream<List<TodoModel>>? requestTodoModels() {
    try {
      final query =
          FirebaseFirestore.instance.collection('todo_list').snapshots();
      return query.handleError(
        (onError, test) {
          Logger().e(
            onError.toString(),
          );
          Logger().e(
            test.toString(),
          );
        },
      ).map<List<TodoModel>>(
        (event) => event.docs.map<TodoModel>(
          (e) {
            return TodoModel.fromMap(
              e.data(),
              e.id,
            );
          },
        ).toList(),
      );
    } catch (e) {
      Logger().e(
        e.toString(),
      );
    }
    return null;
  }

  Future<String> fsAddDoc({
    required String collection,
    required Map<String, dynamic> model,
  }) async {
    return await FirebaseFirestore.instance
        .collection(collection)
        .add(model)
        .then(
      (value) {
        return value.id;
      },
    ).catchError((error) => '$collection $model error: $error');
  }

  Future<void> fsUpdateOneDocWithId(
      {required String collection,
      required String docId,
      required Map<String, dynamic> model}) async {
    await FirebaseFirestore.instance
        .collection(
          collection,
        )
        .doc(
          docId,
        )
        .update(
          model,
        );
  }
}
