// Package imports:
// ignore_for_file: depend_on_referenced_packages

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/constants/api_enpoints.dart';
import 'package:waterbus_sdk/constants/http_status_code.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/types/error/failures.dart';
import 'package:waterbus_sdk/types/models/exceptions/exceptions.dart';
import 'package:waterbus_sdk/types/models/user_model.dart';
import 'package:waterbus_sdk/types/result.dart';

abstract class UserRemoteDataSource {
  Future<Result<User>> getUserProfile();
  Future<Result<bool>> updateUserProfile(User user);
  Future<Result<bool>> updateUsername(String username);
  Future<Result<bool>> checkUsername(String username);
  Future<Result<List<User>>> searchUsers({
    required String keyword,
    required int skip,
    required int limit,
  });
  Future<Result<String>> getPresignedUrl();
  Future<Result<String>> uploadImageToS3({
    required String uploadUrl,
    required Uint8List image,
  });
}

@LazySingleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  final BaseRemoteData _remoteData;
  UserRemoteDataSourceImpl(this._remoteData);

  @override
  Future<Result<String>> getPresignedUrl() async {
    final Response response = await _remoteData.postRoute(
      ApiEndpoints.presignedUrlS3,
    );

    if (response.statusCode == StatusCode.created) {
      final Map<String, dynamic> rawData = response.data;
      return Result.success(rawData['presignedUrl']);
    }

    return Result.failure(ServerFailure());
  }

  @override
  Future<Result<String>> uploadImageToS3({
    required String uploadUrl,
    required Uint8List image,
  }) async {
    try {
      final Uri uri = Uri.parse(uploadUrl);

      final http.Response response = await http.put(
        uri,
        body: image,
        headers: const {"Content-Type": 'image/png'},
      );

      if (response.statusCode == StatusCode.ok) {
        return Result.success(uploadUrl.split('?').first);
      }

      return Result.failure(ServerFailure());
    } catch (error) {
      return Result.failure(ServerFailure());
    }
  }

  @override
  Future<Result<User>> getUserProfile() async {
    final Response response = await _remoteData.getRoute(ApiEndpoints.users);

    if (response.statusCode == StatusCode.ok) {
      final Map<String, dynamic> rawData = response.data;
      return Result.success(User.fromMap(rawData));
    }

    return Result.failure(response.data['message'].toString().userException);
  }

  @override
  Future<Result<bool>> updateUserProfile(User user) async {
    final Response response = await _remoteData.putRoute(
      ApiEndpoints.users,
      user.toMap(),
    );

    if (response.statusCode == StatusCode.ok) {
      return Result.success(true);
    }

    return Result.failure(response.data['message'].toString().userException);
  }

  @override
  Future<Result<bool>> updateUsername(String username) async {
    final Response response = await _remoteData.putRoute(
      "${ApiEndpoints.username}/$username",
      {},
    );

    if (response.statusCode == StatusCode.ok) {
      return Result.success(true);
    }

    return Result.failure(response.data['message'].toString().userException);
  }

  @override
  Future<Result<bool>> checkUsername(String username) async {
    final Response response = await _remoteData.getRoute(
      "${ApiEndpoints.username}/$username",
    );

    if (response.statusCode == StatusCode.ok) {
      return Result.success(response.data['isRegistered'] ?? false);
    }

    return Result.failure(response.data['message'].toString().userException);
  }

  @override
  Future<Result<List<User>>> searchUsers({
    required String keyword,
    required int skip,
    required int limit,
  }) async {
    final Response response = await _remoteData.getRoute(
      ApiEndpoints.searchUsers,
      query: "q=$keyword&limit=$limit&skip=$skip",
    );

    if (response.statusCode == StatusCode.ok) {
      final List data = response.data['hits'];

      return Result.success(
        data.map((user) => User.fromMap(user['document'])).toList(),
      );
    }

    return Result.failure(response.data['message'].toString().userException);
  }
}
