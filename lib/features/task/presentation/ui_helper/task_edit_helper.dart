import 'package:todo/features/user/domain/enity/user_info.dart';

class TaskEditHelper {
  static String? validateTaskName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter task title';
    }
    return null;
  }

  static String? validateTaskDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter task title';
    }
    return null;
  }

  static List<UserInfo> getRemovedUser(
      List<UserInfo> previousUsers, List<UserInfo> newUsers) {
    final List<UserInfo> users = [...previousUsers];
    for (UserInfo user in newUsers) {
      users.remove(user);
    }
    return users;
  }
}
