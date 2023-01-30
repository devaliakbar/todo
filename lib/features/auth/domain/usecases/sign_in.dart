import 'package:todo/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:todo/core/usecases/usecase.dart';
import 'package:todo/features/auth/domain/enity/user_info.dart';
import 'package:todo/features/auth/domain/irepository/iauth_repository.dart';

class SignIn extends UseCase<UserInfo, NoParams> {
  final IAuthRepository _authRepository;

  SignIn({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, UserInfo>> call(NoParams params) async {
    return await _authRepository.signIn();
  }
}
