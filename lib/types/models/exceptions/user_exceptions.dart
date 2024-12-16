part of 'exceptions.dart';

enum UserException {
  userNotFound("User not found"),
  usernameIsAlreadyUsed("Username is already used"),
  ;

  const UserException(this.message);

  final String message;

  Failure get userFailure => switch (this) {
        UserException.userNotFound => UserNotFound(),
        UserException.usernameIsAlreadyUsed => UserIsAlreadyUsed(),
      };
}

extension UserExceptionX on String {
  Failure get userException {
    final int index = UserException.values
        .indexWhere((exception) => exception.message == this);

    if (index == -1) return ServerFailure();

    return UserException.values[index].userFailure;
  }
}
