import 'package:dartz/dartz.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../../core/network/network_info.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/user_repository.dart';
import '../local/user_local_data_source.dart';
import '../remote/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<User>>> getUsers(int page, int limit) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUsers = await remoteDataSource.getUsers(page, limit);
        await localDataSource.cacheUsers(remoteUsers, page);
        return Right(remoteUsers);
      } on ServerException catch (e) {
        return Left(ServerFailure(
          e.message ?? 'Failed to fetch users from the server',
        ));
      } catch (e) {
        return const Left(ServerFailure(
          'An unexpected error occurred while fetching users',
        ));
      }
    } else {
      try {
        final localUsers = await localDataSource.getUsers(page, limit);
        return Right(localUsers);
      } on CacheException catch (e) {
        return Left(CacheFailure(
          e.message ?? 'Failed to retrieve cached users',
        ));
      } catch (e) {
        return const Left(CacheFailure(
          'An unexpected error occurred while retrieving cached users',
        ));
      }
    }
  }
}
