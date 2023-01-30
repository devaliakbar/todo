import 'package:todo/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:todo/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:todo/features/auth/data/model/user_info_model.dart';
import 'package:todo/features/auth/domain/enity/user_info.dart';
import 'package:todo/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:todo/features/auth/domain/irepository/iauth_repository.dart';

class AuthRepository extends IAuthRepository {
  final IAuthRemoteDataSource _authRemoteDataSource;
  final IAuthLocalDataSource _authLocalDataSource;
  AuthRepository(
      {required IAuthRemoteDataSource authRemoteDataSource,
      required IAuthLocalDataSource authLocalDataSource})
      : _authRemoteDataSource = authRemoteDataSource,
        _authLocalDataSource = authLocalDataSource;

  @override
  Future<Either<Failure, UserInfo>> signIn() async {
    try {
      final UserInfoModel userInfo = await _authRemoteDataSource.signIn();
      await _authLocalDataSource.saveUserDetails(userInfo: userInfo);
      return Right(userInfo);
    } catch (_) {}

    return Left(UnexpectedFailure());
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _authRemoteDataSource.signOut();
      await _authLocalDataSource.deleteUserDetails();
      return const Right(null);
    } catch (_) {}

    return Left(UnexpectedFailure());
  }

  @override
  Future<Either<Failure, UserInfo>> checkSignIn() async {
    try {
      return Right(await _authLocalDataSource.checkSignIn());
    } catch (_) {}

    return Left(UnexpectedFailure());
  }
}
