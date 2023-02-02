import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:todo/features/user/domain/enity/user_info.dart';

class UserInfoModel extends UserInfo {
  const UserInfoModel(
      {required super.id, required super.fullName, required super.profilePic});

  factory UserInfoModel.fromFirebase(firebase_auth.User user) {
    return UserInfoModel(
        id: user.uid,
        fullName: user.displayName ?? "Unknown",
        profilePic: user.photoURL);
  }

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
        id: json["id"],
        fullName: json["fullName"],
        profilePic: json["profilePic"]);
  }

  static Map<String, dynamic> toJson(UserInfoModel userInfo) {
    return {
      "id": userInfo.id,
      "fullName": userInfo.fullName,
      "profilePic": userInfo.profilePic
    };
  }
}

class UserInfoResponseModel extends UserInfoModel {
  final List<String> notificationTokens;
  const UserInfoResponseModel(
      {required super.id,
      required super.fullName,
      required super.profilePic,
      required this.notificationTokens});

  factory UserInfoResponseModel.fromJson(Map<String, dynamic> json) {
    return UserInfoResponseModel(
        id: json["id"],
        fullName: json["fullName"],
        profilePic: json["profilePic"],
        notificationTokens: mapTokens(json["notificationTokens"]));
  }

  static Map<String, dynamic> toJson(UserInfoResponseModel userInfo) {
    return {
      "id": userInfo.id,
      "fullName": userInfo.fullName,
      "profilePic": userInfo.profilePic,
      "notificationTokens": userInfo.notificationTokens
    };
  }

  static List<String> mapTokens(List<dynamic> jsonArr) {
    final List<String> tokens = [];
    for (var element in jsonArr) {
      tokens.add(element);
    }

    return tokens;
  }

  @override
  List<Object?> get props => [id, fullName, profilePic, notificationTokens];
}
