import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/user_repository.dart';
import '../local/user_local_data_source.dart';
import '../remote/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<User>>> getUsers(int page, int limit) async {
    try {
      final remoteUsers = await remoteDataSource.getUsers(page, limit);
      await localDataSource.cacheUsers(remoteUsers, page);
      return Right(remoteUsers);
    } on ServerException {
      try {
        final localUsers = await localDataSource.getUsers(page, limit);
        return Right(localUsers);
      } on CacheException catch (e) {
        return Left(CacheFailure(
          e.message ?? 'Failed to retrieve cached users',
        ));
      } catch (e) {
        return Left(
          ServerFailure("Failed to retrieve users from server."),
        );
        // return const Left(CacheFailure(
        //   'An unexpected error occurred while retrieving cached users',
        // ));
      }
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          e.response?.data['message'].toString() ??
              'Error occurred Please try again',
        ),
      );
    }
  }
}
