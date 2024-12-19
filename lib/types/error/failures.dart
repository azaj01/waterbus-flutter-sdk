import 'package:equatable/equatable.dart';

part "meeting_failure.dart";
part "message_failure.dart";
part "user_failure.dart";

abstract class Failure extends Equatable {
  final String? message;

  const Failure([this.message]);

  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NullValue extends Failure {}
