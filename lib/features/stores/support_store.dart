import 'package:practice2/features/entities/message.dart';

abstract class SupportStore {
  List<Message> getMessages();
  void sendMessage(String text);
  Stream<List<Message>> watchMessages();
}
