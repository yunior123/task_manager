import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/widgets/add_todo_dialog.dart';

import '../models/todo_model.dart';
import '../providers/todo_list_provider.dart';
import '../widgets/status_selector.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PreferredSize _getAppBar(BuildContext ctx) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Stack(
          children: <Widget>[
            Container(
              child: const Center(
                child: Text(
                  "Task Manager",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
              color: Colors.blue,
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
            ),

            Container(), // Required some widget in between to float AppBar

            Positioned(
              top: 100.0,
              left: 20.0,
              right: 20.0,
              child: AppBar(
                backgroundColor: Colors.white,
                leading: Icon(
                  Icons.menu,
                  color: Colors.green[800]!,
                ),
                primary: false,
                title: TextField(
                  onChanged: (value) {
                    ctx.read<TodoProvider>().onFiltered(
                          value,
                        );
                  },
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Get.theme.disabledColor,
                    ),
                  ),
                ),
                actions: <Widget>[
                  const IconButton(
                    disabledColor: Colors.grey,
                    icon: Icon(
                      Icons.close,
                    ),
                    onPressed: null,
                  ),
                  IconButton(
                    icon: Badge(
                      badgeContent: const Text('3'), //TODO
                      child: Icon(
                        Icons.notifications,
                        color: Colors.green[800]!,
                      ),
                    ),
                    onPressed: () {},
                  )
                ],
              ),
            )
          ],
        ),
      );
    }

    return ChangeNotifierProvider<TodoProvider>(
      create: (_) => TodoProvider(),
      builder: (context, _) {
        final todoProvider = Provider.of<TodoProvider>(
          context,
          listen: false,
        );
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              child: const Icon(
                Icons.add,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AddTodoDialog();
                  },
                );
              },
            ),
            endDrawer: const Drawer(),
            appBar: _getAppBar(context),
            body: Center(
              child: StreamBuilder<List<TodoModel>?>(
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SpinKitChasingDots(
                      color: Colors.blue,
                    );
                  }
                  final items = snapshot.data;

                  if (items != null && items.isNotEmpty) {
                    todoProvider.setTodos = items;
                    return _TodoList();
                  }
                  return const Center(
                    child: Text("No data"),
                  );
                },
                stream: todoProvider.requestTodos(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: todoProvider.getTodos.length,
        itemBuilder: (context, index) {
          final item = todoProvider.getTodos[index];
          final formatter = DateFormat.yMEd();
          final time = formatter.format(item.datetime);
          return Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _CardItem(label: 'Title: ', content: item.title),
                  _CardItem(label: 'Description: ', content: item.description),
                  _CardItem(label: 'Type: ', content: item.type),
                  _CardItem(label: 'Project: ', content: item.project),
                  _CardItem(label: 'Author: ', content: item.author),
                  _CardItem(label: 'Time: ', content: time),
                  StatusButton(
                    onStatusChanged: (status) => todoProvider.updateTodoStatus(
                      item.docId,
                      status,
                    ),
                    initialStatus: item.status,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CardItem extends StatelessWidget {
  final String label;
  final String content;
  const _CardItem({
    Key? key,
    required this.label,
    required this.content,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 150,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  label,
                  style: TextStyle(
                    color: Theme.of(context).errorColor,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                content,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
