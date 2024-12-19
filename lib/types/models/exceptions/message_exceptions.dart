part of 'exceptions.dart';

enum MessageException {
  roomNotFound("Room Not Found"),
  notAllowedGetMessages(
    "You not allowed get messages from room that you not stay in there",
  ),
  notAllowedModifyMessage("You not allowed modify message of other users"),
  userNotFound('User not found'),
  messageHasBeenDelete('Message has been deleted'),
  messageNotFound("Message not found"),
  ;

  const MessageException(this.message);

  final String message;

  Failure get messageFailure => switch (this) {
        MessageException.roomNotFound => RoomNotFound(),
        MessageException.userNotFound => UserNotFound(),
        MessageException.messageNotFound => MessageNotFound(),
        MessageException.messageHasBeenDelete => MessageHasBeenDelete(),
        MessageException.notAllowedGetMessages => NotAllowedGetMessages(),
        MessageException.notAllowedModifyMessage => NotAllowedModifyMessage(),
      };
}

extension MessageExceptionX on String {
  Failure get messageException {
    final int index = MessageException.values
        .indexWhere((exception) => exception.message == this);

    if (index == -1) return ServerFailure();

    return MessageException.values[index].messageFailure;
  }
}
