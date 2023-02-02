import 'package:dartz/dartz.dart';
import 'package:todo/core/error/failures.dart';
import 'package:todo/features/user/domain/enity/user_info.dart';

abstract class IAuthRepository {
  Future<Either<Failure, UserInfo>> signIn();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, UserInfo>> checkSignIn();
}
