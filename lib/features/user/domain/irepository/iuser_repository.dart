import 'package:dartz/dartz.dart';
import 'package:todo/core/error/failures.dart';
import 'package:todo/features/user/domain/enity/user_info.dart';

abstract class IUserRepository {
  Future<Either<Failure, List<UserInfo>>> getUsers();
}
