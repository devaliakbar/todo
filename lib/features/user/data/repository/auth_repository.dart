import 'package:todo/features/user/data/datasource/user_local_data_source.dart';
import 'package:todo/features/user/data/datasource/user_remote_data_source.dart';
import 'package:todo/features/user/data/model/user_info_model.dart';
import 'package:todo/features/user/domain/enity/user_info.dart';
import 'package:todo/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:todo/features/user/domain/irepository/iauth_repository.dart';

class AuthRepository extends IAuthRepository {
  final IUserRemoteDataSource _userRemoteDataSource;
  final IUserLocalDataSource _userLocalDataSource;
  AuthRepository(
      {required IUserRemoteDataSource userRemoteDataSource,
      required IUserLocalDataSource userLocalDataSource})
      : _userRemoteDataSource = userRemoteDataSource,
        _userLocalDataSource = userLocalDataSource;

  @override
  Future<Either<Failure, UserInfo>> signIn() async {
    try {
      final UserInfoModel userInfo = await _userRemoteDataSource.signIn();
      await _userLocalDataSource.saveUserDetails(userInfo: userInfo);
      return Right(userInfo);
    } catch (_) {}

    return Left(UnexpectedFailure());
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _userRemoteDataSource.signOut();
      await _userLocalDataSource.deleteUserDetails();
      return const Right(null);
    } catch (_) {}

    return Left(UnexpectedFailure());
  }

  @override
  Future<Either<Failure, UserInfo>> checkSignIn() async {
    try {
      return Right(await _userLocalDataSource.checkSignIn());
    } catch (_) {}

    return Left(UnexpectedFailure());
  }
}
