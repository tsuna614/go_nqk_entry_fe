import 'package:equatable/equatable.dart';

abstract class SubscribeStates extends Equatable {
  const SubscribeStates();

  @override
  List<Object> get props => [];
}

class SubscribeInitialState extends SubscribeStates {}

class SubscribeLoadingState extends SubscribeStates {
  @override
  List<Object> get props => [];
}

class SubscribeSuccessState extends SubscribeStates {
  final String message;

  const SubscribeSuccessState(this.message);

  @override
  List<Object> get props => [message];
}

class SubscribeErrorState extends SubscribeStates {
  final String message;

  const SubscribeErrorState(this.message);

  @override
  List<Object> get props => [message];
}
