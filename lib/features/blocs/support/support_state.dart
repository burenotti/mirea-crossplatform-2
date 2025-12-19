import 'package:practice2/features/entities/message.dart';

abstract class SupportState {}

class SupportInitial extends SupportState {}

class SupportLoading extends SupportState {}

class SupportLoaded extends SupportState {
  final List<Message> messages;

  SupportLoaded(this.messages);
}

class SupportError extends SupportState {
  final String message;

  SupportError(this.message);
}
