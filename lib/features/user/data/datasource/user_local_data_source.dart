import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/core/error/exceptions.dart';
import 'package:todo/features/user/data/model/user_info_model.dart';
import 'package:todo/features/user/domain/enity/user_info.dart';

abstract class IUserLocalDataSource {
  Future<void> saveUserDetails({required UserInfoModel userInfo});
  Future<void> deleteUserDetails();

  /// Throws a [UnexpectedException] for any failure.
  Future<UserInfo> checkSignIn();
}

class UserLocalDataSource extends IUserLocalDataSource {
  static const _userInfoKey = "user_info";

  ///***************************************************************************************************************************///                                              ///
  ///                                                                                                                           ///
  ///***************************************************************************************************************************///
  @override
  Future<void> saveUserDetails({required UserInfoModel userInfo}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _userInfoKey, jsonEncode(UserInfoModel.toJson(userInfo)));
  }

  ///***************************************************************************************************************************///                                              ///
  ///                                                                                                                           ///
  ///***************************************************************************************************************************///
  @override
  Future<void> deleteUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_userInfoKey);
  }

  ///***************************************************************************************************************************///                                              ///
  ///                                                                                                                           ///
  ///***************************************************************************************************************************///
  @override
  Future<UserInfo> checkSignIn() async {
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
