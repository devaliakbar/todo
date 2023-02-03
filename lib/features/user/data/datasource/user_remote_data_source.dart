import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:todo/core/error/exceptions.dart';
import 'package:todo/core/res/app_resources.dart';
import 'package:todo/features/user/data/model/user_info_model.dart';

abstract class IUserRemoteDataSource {
  /// Throws a [UnexpectedException] for any failure.
  Future<UserInfoModel> signIn();

  Future<void> signOut();

  Future<List<UserInfoModel>> getUsers();
}

class UserRemoteDataSource extends IUserRemoteDataSource {
  final Logger _logger;

  UserRemoteDataSource({required Logger logger}) : _logger = logger;

  @override
  Future<UserInfoModel> signIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential result = await auth.signInWithCredential(authCredential);
      User? user = result.user;

      await googleSignIn.signOut();

      if (user != null) {
        final UserInfoModel userInfoModel = UserInfoModel.fromFirebase(user);
        await _saveUserDetails(userInfoModel);
        return userInfoModel;
      }
    }

    throw UnexpectedException();
  }

  @override
  Future<void> signOut() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    await _deleteNotificationToken(userId: auth.currentUser?.uid);

    await auth.signOut();
  }

  @override
  Future<List<UserInfoModel>> getUsers() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection(FirestoreCollectionNames.cUser);

    var result = await users.orderBy('fullName', descending: false).get();

    List<UserInfoResponseModel> usersRes = [];
    for (var element in result.docs) {
      usersRes.add(UserInfoResponseModel.fromJson(
          element.data() as Map<String, dynamic>));
    }

    return usersRes;
  }

  Future<void> _saveUserDetails(UserInfoModel userInfoModel) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection(FirestoreCollectionNames.cUser);

    final String? notificationToken =
        await FirebaseMessaging.instance.getToken();

    var result = await users.where('id', isEqualTo: userInfoModel.id).get();
    if (result.docs.isNotEmpty) {
      if (notificationToken != null) {
        final List<String> tokens = UserInfoResponseModel.mapTokens(
            (result.docs.single.data()
                as Map<String, dynamic>)["notificationTokens"]);

        tokens.add(notificationToken);
        await result.docs.single.reference
            .update({"notificationTokens": tokens})
            .then((value) =>
                _logger.i("User new notification token added to firestore"))
            .catchError((err) {
              _logger.e(
                  "Failed to add user new notification token to firestore: $err");
              throw FirestoreException();
            });
      }
    } else {
      final Map<String, dynamic> user = UserInfoModel.toJson(userInfoModel);
      user["notificationTokens"] =
          notificationToken == null ? [] : [notificationToken];

      await users
          .add(user)
          .then((value) => _logger.i("User added to firestore"))
          .catchError((error) {
        _logger.e("Failed to add user to firestore: $error");
        throw FirestoreException();
      });
    }
  }

  Future<void> _deleteNotificationToken({required String? userId}) async {
    try {
      final String? notificationToken =
          await FirebaseMessaging.instance.getToken();

      if (notificationToken != null) {
        await FirebaseMessaging.instance.deleteToken();

        if (userId != null) {
          CollectionReference users = FirebaseFirestore.instance
              .collection(FirestoreCollectionNames.cUser);
          var result = await users.where('id', isEqualTo: userId).get();
          if (result.docs.isNotEmpty) {
            final List<String> tokens = UserInfoResponseModel.mapTokens(
                (result.docs.single.data()
                    as Map<String, dynamic>)["notificationTokens"]);

            tokens.remove(notificationToken);

            await result.docs.single.reference
                .update({"notificationTokens": tokens})
                .then((value) => _logger
                    .i("User old notification token removed from firestore"))
                .catchError((err) => _logger.e(
                    "Failed to remove user old notification token from firestore: $err"));
          }
        }
      }
    } catch (e) {
      _logger.e("Failed to remove notification token from server $e");
    }
  }
}
