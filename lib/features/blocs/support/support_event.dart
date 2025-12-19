import 'package:practice2/features/entities/message.dart';

abstract class SupportEvent {}

class LoadMessages extends SupportEvent {}

class SendMessage extends SupportEvent {
  final String text;

  SendMessage(this.text);
}

class MessagesUpdated extends SupportEvent {
  final List<Message> messages;

  MessagesUpdated(this.messages);
}
