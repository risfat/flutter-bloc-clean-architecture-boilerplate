import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/constants.dart';
import '../../../core/network/api.dart';
import '../../../core/utilities/logger.dart';

abstract class AuthenticationRemoteDataSource {
  Future<void> login(String email, String password);
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final Dio dio;

  AuthenticationRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> login(String email, String password) async {
    print(
        "Login request to $API.LOGIN with email: $email, password: $password...  \n");
    try {
      final prefs = await SharedPreferences.getInstance();
      final response = await dio.post(API.LOGIN, data: {
        'username': email,
        'password': password,
      });
      final String? token = response.data["accessToken"];
      if (token != null) {
        await prefs.setString(ACCESS_TOKEN, token);
      }
      logger.info('Login successful');
    } catch (e) {
      logger.error('Login failed', error: e);
      rethrow;
    }
  }
}
