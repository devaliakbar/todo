import 'package:todo/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:todo/core/usecases/usecase.dart';
import 'package:todo/features/user/domain/enity/user_info.dart';
import 'package:todo/features/user/domain/irepository/iuser_repository.dart';

class GetUsers extends UseCase<List<UserInfo>, NoParams> {
  final IUserRepository _userRepository;

  GetUsers({required IUserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<Either<Failure, List<UserInfo>>> call(NoParams params) async {
    return await _userRepository.getUsers();
  }
}
