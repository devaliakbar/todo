import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationMessageModel extends Equatable {
  final String messageTitle;
  final String messsageBody;

  const NotificationMessageModel(
      {required this.messageTitle, required this.messsageBody});

  factory NotificationMessageModel.fromRemoteMessage(
      RemoteMessage remoteMessage) {
    return NotificationMessageModel(
        messageTitle: remoteMessage.notification?.title ?? "",
        messsageBody: remoteMessage.notification?.body ?? "");
  }

  @override
  List<Object?> get props => [messageTitle, messsageBody];
}
