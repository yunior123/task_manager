import 'package:get/get.dart';
import 'package:task_manager/resources/todos_api.dart';

class DependencyInjection {
  static void init() {
    Get.lazyPut(() => TodosApi());
  }
}
