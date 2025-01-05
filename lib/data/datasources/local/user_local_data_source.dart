import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/config/boxs.dart';
import '../../../core/error/exceptions.dart';
import '../../../domain/entities/user.dart';
import '../../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<List<User>> getUsers(int page, int limit);
  Future<void> cacheUsers(List<UserModel> users, int page);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Box<String> userBox;

  UserLocalDataSourceImpl({required this.userBox});

  @override
  Future<List<UserModel>> getUsers(int page, int limit) async {
    final jsonString = userBox.get(HiveBox.cachedUsersKey);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        final allUsers = jsonList
            .map<UserModel>((json) => UserModel.fromJson(json))
            .toList();

        // Apply pagination
        final startIndex = (page - 1) * limit;
        final endIndex = startIndex + limit;
        return allUsers.sublist(
          startIndex,
          endIndex > allUsers.length ? allUsers.length : endIndex,
        );
      } catch (e) {
        throw CacheException(
          'Failed to parse cached user data: ${e.toString()}',
        );
      }
    } else {
      throw CacheException('No cached user data found');
    }
  }

  @override
  Future<void> cacheUsers(List<UserModel> usersToCache, int page) async {
    final existingJsonString = userBox.get(HiveBox.cachedUsersKey);
    List<UserModel> allUsers = [];

    if (existingJsonString != null) {
      final List<dynamic> existingJsonList = json.decode(existingJsonString);
      allUsers = existingJsonList
          .map<UserModel>((json) => UserModel.fromJson(json))
          .toList();
    }

    // Replace or append new users based on the page
    final startIndex = (page - 1) * usersToCache.length;
    if (startIndex < allUsers.length) {
      // Replace existing users
      for (int i = 0; i < usersToCache.length; i++) {
        if (startIndex + i < allUsers.length) {
          allUsers[startIndex + i] = usersToCache[i];
        } else {
          allUsers.add(usersToCache[i]);
        }
      }
    } else {
      // Append new users
      allUsers.addAll(usersToCache);
    }

    final jsonString =
        json.encode(allUsers.map((user) => user.toJson()).toList());
    await userBox.put(HiveBox.cachedUsersKey, jsonString);
  }
}
