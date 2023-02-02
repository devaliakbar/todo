import 'package:todo/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:todo/core/usecases/usecase.dart';
import 'package:todo/features/user/domain/irepository/iauth_repository.dart';

class SignOut extends UseCase<void, NoParams> {
  final IAuthRepository _authRepository;

  SignOut({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await _authRepository.signOut();
  }
}
