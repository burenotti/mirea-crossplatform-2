import 'dart:async';
import 'package:practice2/features/entities/message.dart';
import 'package:practice2/features/stores/support_store.dart';

typedef MessageIdGenerator = int Function();

class SupportStoreImpl implements SupportStore {
  final List<Message> _messages = [];
  final MessageIdGenerator nextMessageId;
  final DateTime Function() currentDateTime;
  final _controller = StreamController<List<Message>>.broadcast();

  SupportStoreImpl({
    required this.nextMessageId,
    required this.currentDateTime,
  });

  @override
  List<Message> getMessages() {
    return List.unmodifiable(_messages);
  }

  @override
  void sendMessage(String text) {
    final userMessage = Message(
      id: nextMessageId(),
      text: text,
      isUser: true,
      timestamp: currentDateTime(),
    );

    _messages.add(userMessage);
    _controller.add(getMessages());

    Future.delayed(const Duration(seconds: 1), () {
      final supportMessage = Message(
        id: nextMessageId(),
        text: '[полезный ответ от поддержки]',
        isUser: false,
        timestamp: currentDateTime(),
      );

      _messages.add(supportMessage);
      _controller.add(getMessages());
    });
  }

  @override
  Stream<List<Message>> watchMessages() async* {
    yield getMessages();

    await for (final messages in _controller.stream) {
      yield messages;
    }
  }

  void dispose() {
    _controller.close();
  }
}
