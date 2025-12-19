import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:practice2/features/blocs/support/support_event.dart';
import 'package:practice2/features/blocs/support/support_state.dart';
import 'package:practice2/features/stores/support_store.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final SupportStore supportStore;
  StreamSubscription? _messagesSubscription;

  SupportBloc({required this.supportStore}) : super(SupportInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<MessagesUpdated>(_onMessagesUpdated);
  }

  void _onLoadMessages(LoadMessages event, Emitter<SupportState> emit) {
    emit(SupportLoading());

    _messagesSubscription?.cancel();
    _messagesSubscription = supportStore.watchMessages().listen((messages) {
      add(MessagesUpdated(messages));
    });
  }

  void _onSendMessage(SendMessage event, Emitter<SupportState> emit) {
    try {
      supportStore.sendMessage(event.text);
    } catch (e) {
      emit(SupportError('Не удалось отправить сообщение'));
    }
  }

  void _onMessagesUpdated(MessagesUpdated event, Emitter<SupportState> emit) {
    emit(SupportLoaded(event.messages));
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
