part of 'municipal_advisor_bloc.dart';

class MunicipalAdvisorState extends Equatable {
  final BlocRequestStatus status;
  final List<ChatMessage> messages;

  const MunicipalAdvisorState({
    this.status = BlocRequestStatus.initial,
    this.messages = const <ChatMessage>[],
  });

  MunicipalAdvisorState copyWith({
    BlocRequestStatus? status,
    List<ChatMessage>? messages,
  }) {
    return MunicipalAdvisorState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object> get props => [
        status,
        messages,
      ];
}
