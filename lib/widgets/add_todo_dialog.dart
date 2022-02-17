import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/add_todo_provider.dart';
import 'package:task_manager/widgets/border_button.dart';

class AddTodoDialog extends StatelessWidget {
  AddTodoDialog({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddTodoProvider(),
      builder: (context, _) {
        final provider = Provider.of<AddTodoProvider>(context);

        return Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 400,
            ),
            margin: const EdgeInsets.fromLTRB(
              20,
              15,
              20,
              30,
            ),
            child: SingleChildScrollView(
              child: Card(
                margin: const EdgeInsets.fromLTRB(
                  2,
                  1,
                  2,
                  20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    30.0,
                  ),
                ),
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) =>
                              (value != null && value.isNotEmpty)
                                  ? null
                                  : 'Please enter a title',
                          decoration: const InputDecoration(
                            label: Text('Title'),
                          ),
                          onSaved: (value) => provider.title(value!),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) =>
                              (value != null && value.isNotEmpty)
                                  ? null
                                  : 'Please enter a description',
                          decoration: const InputDecoration(
                            label: Text('Description'),
                          ),
                          onSaved: (value) => provider.description(value!),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) =>
                              (value != null && value.isNotEmpty)
                                  ? null
                                  : 'Please enter a type',
                          decoration: const InputDecoration(
                            label: Text('Type'),
                          ),
                          onSaved: (value) => provider.type(value!),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) =>
                              (value != null && value.isNotEmpty)
                                  ? null
                                  : 'Please enter an author',
                          decoration: const InputDecoration(
                            label: Text('Author'),
                          ),
                          onSaved: (value) => provider.author(value!),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) =>
                              (value != null && value.isNotEmpty)
                                  ? null
                                  : 'Please enter a project',
                          decoration: const InputDecoration(
                            label: Text('Project'),
                          ),
                          onSaved: (value) => provider.project(value!),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        BorderButton(
                          text: 'Save',
                          color: Colors.blue,
                          onPressed: () async {
                            final isValid = formKey.currentState!.validate();
                            if (isValid) {
                              formKey.currentState!.save();
                              await provider.saveTodo(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
