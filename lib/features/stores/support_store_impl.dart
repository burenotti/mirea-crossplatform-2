import 'dart:async';
import 'package:practice2/features/entities/app_action.dart';
import 'package:practice2/features/entities/message.dart';
import 'package:practice2/features/stores/actions_store.dart';
import 'package:practice2/features/stores/support_store.dart';

typedef MessageIdGenerator = int Function();

class SupportStoreImpl implements SupportStore {
  final List<Message> _messages = [];
  final MessageIdGenerator nextMessageId;
  final DateTime Function() currentDateTime;
  final ActionsStore actionsStore;
  final _controller = StreamController<List<Message>>.broadcast();

  SupportStoreImpl({
    required this.nextMessageId,
    required this.currentDateTime,
    required this.actionsStore,
  });

  @override
  List<Message> getMessages() {
    return List.unmodifiable(_messages);
  }

  @override
  void sendMessage(String text) {
    final now = currentDateTime();
    final userMessage = Message(
      id: nextMessageId(),
      text: text,
      isUser: true,
      timestamp: now,
    );

    _messages.add(userMessage);
    _controller.add(getMessages());

    // Отправляем событие о сообщении в поддержку
    actionsStore.dispatch(AppAction(
      type: ActionType.supportMessageSent,
      timestamp: now,
      data: {'messageId': userMessage.id},
    ));

    Future.delayed(const Duration(seconds: 1), () {
      final supportMessage = Message(
        id: nextMessageId(),
        text: 'Спасибо за ваш вопрос! Мы обязательно вам поможем.',
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
