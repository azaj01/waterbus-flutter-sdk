import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/constants/api_enpoints.dart';
import 'package:waterbus_sdk/constants/http_status_code.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/models/exceptions/exceptions.dart';
import 'package:waterbus_sdk/types/result.dart';
import 'package:waterbus_sdk/utils/encrypt/encrypt.dart';

abstract class MessageRemoteDataSource {
  Future<Result<List<MessageModel>>> getMessageByRoom({
    required int meetingId,
    required int limit,
    required int skip,
  });

  Future<Result<MessageModel>> sendMessage({
    required int meetingId,
    required String data,
  });
  Future<Result<MessageModel>> editMessage({
    required int messageId,
    required String data,
  });
  Future<Result<MessageModel>> deleteMessage({required int messageId});
}

@LazySingleton(as: MessageRemoteDataSource)
class MessageRemoteDataSourceImpl extends MessageRemoteDataSource {
  final BaseRemoteData _remoteData;

  MessageRemoteDataSourceImpl(
    this._remoteData,
  );

  @override
  Future<Result<List<MessageModel>>> getMessageByRoom({
    required int meetingId,
    required int limit,
    required int skip,
  }) async {
    final Response response = await _remoteData.getRoute(
      "${ApiEndpoints.chats}/$meetingId",
      query: "limit=$limit&skip=$skip",
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      final List<MessageModel> messages = (response.data as List)
          .map((message) => MessageModel.fromMap(message))
          .toList();

      return Result.success(
        await compute(_handleDecryptMessages, {
          "messages": messages,
          "key": WaterbusSdk.privateMessageKey,
        }),
      );
    }

    return Result.failure(
      (response.data['message'] as String).messageException,
    );
  }

  static Future<List<MessageModel>> _handleDecryptMessages(
    Map<String, dynamic> map,
  ) async {
    final List<MessageModel> messages = map['messages'];
    final String key = map['key'];

    final List<MessageModel> messagesDecrypt = [];
    for (final MessageModel messageModel in messages) {
      final String data = await EncryptAES()
          .decryptAES256(cipherText: messageModel.data, key: key);

      messagesDecrypt.add(messageModel.copyWith(data: data));
    }

    return messagesDecrypt;
  }

  @override
  Future<Result<MessageModel>> sendMessage({
    required int meetingId,
    required String data,
  }) async {
    final String messageData =
        await EncryptAES().encryptAES256(cleartext: data);

    final Response response = await _remoteData.postRoute(
      "${ApiEndpoints.chats}/$meetingId",
      body: {"data": messageData},
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      return Result.success(
        MessageModel.fromMap(response.data).copyWith(data: data),
      );
    }

    return Result.failure(
      (response.data['message'] as String).messageException,
    );
  }

  @override
  Future<Result<MessageModel>> editMessage({
    required int messageId,
    required String data,
  }) async {
    final String messageData =
        await EncryptAES().encryptAES256(cleartext: data);
    final Response response = await _remoteData.putRoute(
      "${ApiEndpoints.chats}/$messageId",
      {"data": messageData},
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      return Result.success(
        MessageModel.fromMap(response.data).copyWith(data: data),
      );
    }

    return Result.failure(
      (response.data['message'] as String).messageException,
    );
  }

  @override
  Future<Result<MessageModel>> deleteMessage({
    required int messageId,
  }) async {
    final Response response = await _remoteData.deleteRoute(
      "${ApiEndpoints.chats}/$messageId",
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      return Result.success(MessageModel.fromMap(response.data));
    }

    return Result.failure(
      (response.data['message'] as String).messageException,
    );
  }
}
