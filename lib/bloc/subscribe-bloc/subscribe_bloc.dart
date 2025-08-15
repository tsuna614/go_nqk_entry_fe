import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_nqk_entry_fe/bloc/subscribe-bloc/subscribe_events.dart';
import 'package:go_nqk_entry_fe/bloc/subscribe-bloc/subscribe_states.dart';
import 'package:go_nqk_entry_fe/services/subscribe_service.dart';

class SubscribeBloc extends Bloc<SubscribeEvents, SubscribeStates> {
  final SubscribeService subscribeService;

  SubscribeBloc({required this.subscribeService})
    : super(SubscribeInitialState()) {
    on<SendSubcriptionEvent>(_onSubscribe);
    on<SendUnsubscriptionEvent>(_onUnsubscribe);
  }

  Future<void> _onSubscribe(
    SendSubcriptionEvent event,
    Emitter<SubscribeStates> emit,
  ) async {
    emit(SubscribeLoadingState());
    try {
      final response = await subscribeService.sendSubcription(
        email: event.email,
      );
      if (response.statusCode == 200) {
        emit(SubscribeSuccessState(response.data!.message));
      } else {
        emit(SubscribeErrorState(response.errorMessage ?? 'Unknown error'));
      }
    } catch (e) {
      emit(SubscribeErrorState(e.toString()));
    }
  }

  Future<void> _onUnsubscribe(
    SendUnsubscriptionEvent event,
    Emitter<SubscribeStates> emit,
  ) async {
    emit(SubscribeLoadingState());
    try {
      final response = await subscribeService.sendUnsubscription(
        email: event.email,
      );
      if (response.statusCode == 200) {
        emit(SubscribeSuccessState(response.data!.message));
      } else {
        emit(SubscribeErrorState(response.errorMessage ?? 'Unknown error'));
      }
    } catch (e) {
      emit(SubscribeErrorState(e.toString()));
    }
  }
}
