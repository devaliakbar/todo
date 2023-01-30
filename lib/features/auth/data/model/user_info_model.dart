import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:todo/features/auth/domain/enity/user_info.dart';

class UserInfoModel extends UserInfo {
  const UserInfoModel({required super.id, required super.fullName});

  factory UserInfoModel.fromFirebase(firebase_auth.User user) {
    return UserInfoModel(id: user.uid, fullName: user.displayName ?? "Unknown");
  }

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(id: json["id"], fullName: json["fullName"]);
  }

  static Map<String, dynamic> toJson(UserInfoModel userInfo) {
    return {"id": userInfo.id, "fullName": userInfo.fullName};
  }
}
