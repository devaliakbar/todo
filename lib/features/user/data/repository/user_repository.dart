import 'package:todo/features/user/data/datasource/user_remote_data_source.dart';
import 'package:todo/features/user/domain/enity/user_info.dart';
import 'package:todo/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:todo/features/user/domain/irepository/iuser_repository.dart';

class UserRepository extends IUserRepository {
  final IUserRemoteDataSource _userRemoteDataSource;

  UserRepository({required IUserRemoteDataSource userRemoteDataSource})
      : _userRemoteDataSource = userRemoteDataSource;

  @override
  Future<Either<Failure, List<UserInfo>>> getUsers() async {
    try {
      return Right(await _userRemoteDataSource.getUsers());
    } catch (_) {}

    return Left(UnexpectedFailure());
  }
}
