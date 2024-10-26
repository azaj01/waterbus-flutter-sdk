import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/constants/api_enpoints.dart';
import 'package:waterbus_sdk/constants/http_status_code.dart';
import 'package:waterbus_sdk/core/api/base/base_remote_data.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/utils/encrypt/encrypt.dart';

abstract class ChatRemoteDataSource {
  Future<List<Meeting>> getConversations({
    required int skip,
    required int limit,
    required int status,
  });
  Future<List<Meeting>> getArchivedConversations({
    required int skip,
    required int limit,
  });
  Future<bool> deleteConversation({required int meetingId});
  Future<Meeting?> archivedConversation({required int code});
  Future<Meeting?> leaveConversation({required int code});
  Future<Meeting?> addMember({required int code, required int userId});
  Future<Meeting?> deleteMember({required int code, required int userId});
  Future<Meeting?> acceptInvite({required int meetingId});
  Future<bool> updateConversation({
    required Meeting meeting,
    String? password,
  });
}

@LazySingleton(as: ChatRemoteDataSource)
class ChatRemoteDataSourceImpl extends ChatRemoteDataSource {
  final BaseRemoteData _remoteData;
  ChatRemoteDataSourceImpl(
    this._remoteData,
  );

  @override
  Future<List<Meeting>> getConversations({
    required int skip,
    required int limit,
    required int status,
  }) async {
    final Response response = await _remoteData.getRoute(
      "${ApiEndpoints.meetingConversations}/$status",
      query: "limit=$limit&skip=$skip",
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      final Map<String, dynamic> message = {
        "conversations": (response.data as List)
            .map((meeting) => Meeting.fromMap(meeting))
            .toList(),
        "key": WaterbusSdk.privateMessageKey,
      };

      return await compute(_handleDecryptLastMessage, message);
    }

    return [];
  }

  @override
  Future<List<Meeting>> getArchivedConversations({
    required int skip,
    required int limit,
  }) async {
    final Response response = await _remoteData.getRoute(
      ApiEndpoints.archivedConversations,
      query: "limit=$limit&skip=$skip",
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      final Map<String, dynamic> message = {
        "conversations": (response.data as List)
            .map((meeting) => Meeting.fromMap(meeting))
            .toList(),
        "key": WaterbusSdk.privateMessageKey,
      };

      return await compute(_handleDecryptLastMessage, message);
    }

    return [];
  }

  static Future<List<Meeting>> _handleDecryptLastMessage(
    Map<String, dynamic> map,
  ) async {
    final List<Meeting> conversations = map['conversations'];
    final String key = map['key'];
    final List<Meeting> conversationsDecrypt = [];
    for (final Meeting conversation in conversations) {
      if (conversation.latestMessage == null) {
        conversationsDecrypt.add(conversation);
        continue;
      }

      final String decrypt = await EncryptAES().decryptAES256(
        cipherText: conversation.latestMessage?.data ?? "",
        key: key,
      );

      conversationsDecrypt.add(
        conversation.copyWith(
          latestMessage: conversation.latestMessage?.copyWith(data: decrypt),
        ),
      );
    }

    return conversationsDecrypt;
  }

  @override
  Future<bool> updateConversation({
    required Meeting meeting,
    String? password,
  }) async {
    final Response response = await _remoteData.putRoute(
      ApiEndpoints.meetings,
      meeting.toMapCreate(password: password),
    );

    return response.statusCode == StatusCode.ok;
  }

  @override
  Future<bool> deleteConversation({required int meetingId}) async {
    final response = await _remoteData.deleteRoute(
      "${ApiEndpoints.chatsConversations}/$meetingId",
    );

    return [StatusCode.ok, StatusCode.created].contains(response.statusCode);
  }

  @override
  Future<Meeting?> leaveConversation({required int code}) async {
    final Response response = await _remoteData.deleteRoute(
      '${ApiEndpoints.meetings}/$code',
    );

    if (response.statusCode == StatusCode.ok) {
      final Map<String, dynamic> message = {
        "conversations": [Meeting.fromMap(response.data)],
        "key": WaterbusSdk.privateMessageKey,
      };

      return (await compute(_handleDecryptLastMessage, message)).first;
    }

    return null;
  }

  @override
  Future<Meeting?> acceptInvite({required int meetingId}) async {
    final Response response = await _remoteData.postRoute(
      '${ApiEndpoints.acceptInvite}/$meetingId',
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      final Map<String, dynamic> message = {
        "conversations": [Meeting.fromMap(response.data)],
        "key": WaterbusSdk.privateMessageKey,
      };

      return (await compute(_handleDecryptLastMessage, message)).first;
    }

    return null;
  }

  @override
  Future<Meeting?> addMember({required int code, required int userId}) async {
    final Response response = await _remoteData.postRoute(
      '${ApiEndpoints.meetingMembers}/$code',
      body: {"userId": userId},
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      final Map<String, dynamic> message = {
        "conversations": [Meeting.fromMap(response.data)],
        "key": WaterbusSdk.privateMessageKey,
      };

      return (await compute(_handleDecryptLastMessage, message)).first;
    }

    return null;
  }

  @override
  Future<Meeting?> deleteMember({
    required int code,
    required int userId,
  }) async {
    final Response response = await _remoteData.deleteRoute(
      '${ApiEndpoints.meetingMembers}/$code',
      body: {"userId": userId},
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      final Map<String, dynamic> message = {
        "conversations": [Meeting.fromMap(response.data)],
        "key": WaterbusSdk.privateMessageKey,
      };

      return (await compute(_handleDecryptLastMessage, message)).first;
    }

    return null;
  }

  @override
  Future<Meeting?> archivedConversation({required int code}) async {
    final Response response = await _remoteData.postRoute(
      '${ApiEndpoints.archivedMeeeting}/$code',
    );

    if ([StatusCode.ok, StatusCode.created].contains(response.statusCode)) {
      final Map<String, dynamic> message = {
        "conversations": [Meeting.fromMap(response.data)],
        "key": WaterbusSdk.privateMessageKey,
      };

      return (await compute(_handleDecryptLastMessage, message)).first;
    }

    return null;
  }
}
