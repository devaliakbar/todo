import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo/core/error/exceptions.dart';
import 'package:todo/features/auth/data/model/user_info_model.dart';

abstract class IAuthRemoteDataSource {
  /// Throws a [UnexpectedException] for any failure.
  Future<UserInfoModel> signIn();

  /// Throws a [UnexpectedException] for any failure.
  Future<void> signOut();
}

class AuthRemoteDataSource extends IAuthRemoteDataSource {
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
        return UserInfoModel.fromFirebase(user);
      }
    }

    throw UnexpectedException();
  }

  @override
  Future<void> signOut() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
  }
}
