import 'package:dio/dio.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/network/api.dart';
import '../../../core/network/dio_client.dart';
import '../../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers(int page, int limit);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl({Dio? dio}) : dio = dio ?? DioClient.instance;

  @override
  Future<List<UserModel>> getUsers(int page, int limit) async {
    try {
      final response = await dio.get(
        API.USERS,
        queryParameters: {
          'skip': (page - 1) * limit,
          'limit': limit,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> userList = responseData['users'];
        return userList.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw ServerException(
            "Failed to fetch users: ${response.statusCode} - ${response.data}");
      }
    } on DioException catch (e) {
      throw ServerException(e.toString());
    }
  }
}
