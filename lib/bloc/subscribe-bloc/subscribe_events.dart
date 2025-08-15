abstract class SubscribeEvents {
  const SubscribeEvents();

  List<Object?> get props => [];
}

class SendSubcriptionEvent extends SubscribeEvents {
  final String email;

  const SendSubcriptionEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class SendUnsubscriptionEvent extends SubscribeEvents {
  final String email;

  const SendUnsubscriptionEvent(this.email);

  @override
  List<Object?> get props => [email];
}
