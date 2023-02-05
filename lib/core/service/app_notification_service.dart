import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';
import 'package:todo/core/error/exceptions.dart';
import 'package:todo/core/service/notification_message_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dio/dio.dart';

class AppNotificationService {
  final Logger _logger;

  AppNotificationService({required Logger logger}) : _logger = logger;

  Future<void> setUpNotification() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    try {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        _logger.i('User granted permission');

        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          _logger.i("New push notification received in foreground");

          _sendManualNotification(
              NotificationMessageModel.fromRemoteMessage(message));
        });

        FirebaseMessaging.onBackgroundMessage(
            _firebaseMessagingBackgroundHandler);

        // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        //   _logger.i("User select on the push notification");
        // });

        _logger.i("Push notification added successfully");
      } else {
        _logger.e('User declined or has not accepted permission');
      }
    } catch (e) {
      _logger.e("Failed to set up push notification : $e");
    }
  }

  Future<String?> getNotificationToken() async {
    try {
      return FirebaseMessaging.instance.getToken();
    } catch (e) {
      _logger.e("Failed to get notification token : $e");
    }

    throw FirebaseMessagingException();
  }

  Future<void> deleteNotificationToken() async {
    try {
      return await FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      _logger.e("Failed to delete notification token : $e");
    }

    throw FirebaseMessagingException();
  }

  Future<void> sendNotification(
      {required NotificationMessageModel model,
      required String userToken}) async {
    ///Sending push notification
    await Dio().post(
      'https://fcm.googleapis.com/fcm/send',
      data: {
        "notification": {
          "body": model.messsageBody,
          "title": model.messageTitle
        },
        "to": userToken
      },
      options: Options(headers: {
        "Authorization":
            "key=AAAAGea1uQk:APA91bEcT3fnndXBd_9ol5N0OsxHNHP6445Y-qoRKYm7voqLInFXg3SIj7VERWxFZsvhKOaKhFTQrHb3AzgHDSlzRMu4HqCT5HqMKAOD2FsGEg3sAIGdREX8RiYvPfuGDQ5SkpJ4RMBV"
      }),
    );
  }

  Future<void> _sendManualNotification(
      NotificationMessageModel notificationModel) async {
    try {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);

      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('ChannelId', 'TodoApp',
              channelDescription: 'Manually handling push notification',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker');
      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);
      await flutterLocalNotificationsPlugin.show(
        0,
        notificationModel.messageTitle,
        notificationModel.messsageBody,
        notificationDetails,
      );
    } catch (e) {
      Logger().w("Failed to send notification manually $e");
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Logger().w("New push notification received in background");
}
