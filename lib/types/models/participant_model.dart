// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:waterbus_sdk/types/models/user_model.dart';

class Participant extends Equatable {
  final int id;
  final User? user;
  final bool isMe;
  const Participant({
    required this.id,
    required this.user,
    this.isMe = false,
  });

  Participant copyWith({
    int? id,
    User? user,
    bool? isMe,
  }) {
    return Participant(
      id: id ?? this.id,
      user: user ?? this.user,
      isMe: isMe ?? this.isMe,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user?.toMap(),
      'isMe': isMe,
    };
  }

  factory Participant.fromMap(Map<String, dynamic> map) {
    return Participant(
      id: map['id'] as int,
      user: map['user'] != null && map['user'] is Map<String, dynamic>
          ? User.fromMap(map['user'])
          : null,
      isMe: map['isMe'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Participant.fromJson(String source) =>
      Participant.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Participant(id: $id, user: $user)';

  @override
  bool operator ==(covariant Participant other) {
    if (identical(this, other)) return true;

    return other.id == id && other.user == user && other.isMe == isMe;
  }

  @override
  int get hashCode => id.hashCode ^ user.hashCode ^ isMe.hashCode;

  @override
  List<dynamic> get props {
    return [id, user, isMe];
  }
}
