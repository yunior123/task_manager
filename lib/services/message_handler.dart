import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../resources/todos_api.dart';

class MessageHandler {
  final _todosApi = Get.find<TodosApi>();
  // singleton
  static final MessageHandler _singleton = MessageHandler._internal();
  factory MessageHandler() => _singleton;
  MessageHandler._internal();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Create a [AndroidNotificationChannel] for heads up notifications
  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications', // title
    importance: Importance.max,
  );
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {},
  );
  final AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('ic_stat_ic_notification');
  bool _didNotificationLaunchApp = false;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Set the background messaging handler early on, as a named top-level function
    try {
      await _firebaseMessagingCreateChannel();
      await _firebaseMessagingNotificationAppLaunchDetails();
      await _setForegroundNotificationPresentationOptions();
      await _handlePermissions();
      await _getToken();
      _handleOnMessage();
      _handleOnMessageOpenedApp();
      _onTokenRefresh();
    } catch (e) {
      Logger().e(
        e.toString(),
      );
    }
  }

  Future<void> _getToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      _saveFCMToken(token);
    }
  }

  Future<void> _onTokenRefresh() async {
    FirebaseMessaging.instance.onTokenRefresh.listen(
      (token) {
        _saveFCMToken(token);
      },
    );
  }

  Future<void> _saveFCMToken(String token) async {
    try {
      await _todosApi.fsUpdateOneDocWithId(
        collection: 'todo_users',
        docId: '5ycW5PNYMvSZHVpBhjfg',
        model: {'token': token},
      );
    } catch (e) {
      Logger().e(
        e.toString(),
      );
    }
  }

  Future<void> _firebaseMessagingCreateChannel() async {
    try {
      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      final initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: _selectNotification,
      );
    } catch (e) {
      Logger().e(
        e.toString(),
      );
    }
  }

  Future<void> _firebaseMessagingNotificationAppLaunchDetails() async {
    try {
      final notificationAppLaunchDetails = await flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();
      _didNotificationLaunchApp =
          notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
    } catch (e) {
      Logger().e(
        e.toString(),
      );
    }
  }

  bool get didNotificationLaunchApp => _didNotificationLaunchApp;

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    // await Firebase.initializeApp();
    Logger().d('Handling a background message ${message.messageId}');
  }

  Future<void> _selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  Future<void> _setForegroundNotificationPresentationOptions() async {
    try {
      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e) {
      Logger().e(
        e.toString(),
      );
    }
  }

  Future<void> _handlePermissions() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        Logger().e('User granted provisional permission');
      } else {
        Logger().e('User declined or has not accepted permission');
      }
    } catch (e) {
      Logger().e(
        e.toString(),
      );
    }
  }

  void _handleOnMessage() {
    FirebaseMessaging.onMessage.listen(
      (message) async {
        var data = message.data;

        assert(data.isNotEmpty);
        assert(data['content'] == 'todo_list');

        final notification = message.notification;
        final android = message.notification?.android;
        try {
          if (notification != null && android != null) {
            await flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  importance: Importance.max,
                  priority: Priority.max,
                  enableVibration: true,
                  color: Colors.red,
                  icon: 'ic_stat_ic_notification',
                  playSound: true,
                  sound: const RawResourceAndroidNotificationSound(
                    'slow_spring_board',
                  ),
                  tag: channel.id,
                  groupAlertBehavior: GroupAlertBehavior.all,
                  setAsGroupSummary: false,
                  styleInformation: null,
                ),
              ),
              payload: 'test payload',
            );
          }
        } catch (e) {
          Logger().e(
            e.toString(),
          );
        }
      },
    );
  }

  void _handleOnMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) async {
        try {
          Logger().d('event triggered, notification pushed $event');
          var data = event.data;
          Logger().d('$data');
          assert(data.isNotEmpty);
          assert(data['content'] == 'task_manager');
        } catch (e) {
          Logger().e(
            e.toString(),
          );
        }
      },
    );
  }
}
