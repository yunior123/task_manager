import 'package:task_manager/models/todo_model.dart';
import 'package:task_manager/resources/todos_api.dart';

class TodosApiMock implements TodosApi {
  // singleton
  static final TodosApiMock _singleton = TodosApiMock._internal();
  factory TodosApiMock() {
    return _singleton;
  }
  TodosApiMock._internal();

  @override
  Stream<List<TodoModel>> requestTodoModels() {
    return Stream.value([
      TodoModel(
        docId: '1',
        status: 'Open',
        description: 'Task Description',
        title: 'Test Todo',
        type: 'Onat',
        datetime: DateTime.now(),
        author: 'Test Author',
        project: 'Test Proyect',
      ),
    ]);
  }

  @override
  Future<String> fsAddDoc(
      {required String collection, required Map<String, dynamic> model}) {
    // TODO: implement fsAddDoc
    throw UnimplementedError();
  }

  @override
  Future<void> fsUpdateOneDocWithId(
      {required String collection,
      required String docId,
      required Map<String, dynamic> model}) {
    // TODO: implement fsUpdateOneDocWithId
    throw UnimplementedError();
  }
}
