import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/core/error/exceptions.dart';
import 'package:todo/features/auth/data/model/user_info_model.dart';

abstract class IAuthLocalDataSource {
  Future<void> saveUserDetails({required UserInfoModel userInfo});
  Future<void> deleteUserDetails();

  /// Throws a [UnexpectedException] for any failure.
  Future<UserInfoModel> checkSignIn();
}

class AuthLocalDataSource extends IAuthLocalDataSource {
  static const _userInfoKey = "user_info";

  @override
  Future<void> saveUserDetails({required UserInfoModel userInfo}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _userInfoKey, jsonEncode(UserInfoModel.toJson(userInfo)));
  }

  @override
  Future<void> deleteUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_userInfoKey);
  }

  @override
  Future<UserInfoModel> checkSignIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final String? userJson = prefs.getString(_userInfoKey);
      if (userJson != null) {
        return UserInfoModel.fromJson(jsonDecode(userJson));
      }
    } catch (_) {
      prefs.remove(_userInfoKey);
    }

    throw UnexpectedException();
  }
}
