import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../core/params/pagination_params.dart';
import '../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUsers implements UseCase<List<User>, PaginationParams> {
  final UserRepository repository;

  GetUsers(this.repository);

  @override
  Future<Either<Failure, List<User>>> call(PaginationParams params) async {
    return await repository.getUsers(params.page, params.limit);
  }
}
