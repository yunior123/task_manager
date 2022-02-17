import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'services/inject_dependencies.dart';
import 'services/message_handler.dart';
import 'views/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(
    MessageHandler.firebaseMessagingBackgroundHandler,
  );
  DependencyInjection.init();
  final msgNotifier = MessageHandler();

  await msgNotifier.initialize();

  runApp(
    const _TodoListApp(),
  );
}

class _TodoListApp extends StatelessWidget {
  const _TodoListApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color.fromRGBO(
          32,
          148,
          173,
          0.5,
        ),
      ),
      home: const HomePage(),
    );
  }
}
