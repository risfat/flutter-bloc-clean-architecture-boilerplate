import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/autentication_repository.dart';

class SignIn {
  SignIn(this._repository);
  final AuthenticationRepository _repository;

  Future<Either<Failure, void>> execute(String email, String password) async {
    return await _repository.login(email, password);
  }
}
