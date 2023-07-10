part of 'municipal_advisor_bloc.dart';

class MunicipalAdvisorState extends Equatable {
  final BlocRequestStatus status;
  final List<ChatMessage> messages;
  final ActivityLocation? activityLocation;
  final bool conrimedLocation;

  const MunicipalAdvisorState({
    this.status = BlocRequestStatus.initial,
    this.messages = const <ChatMessage>[],
    this.activityLocation,
    this.conrimedLocation = false,
  });

  MunicipalAdvisorState copyWith({
    BlocRequestStatus? status,
    List<ChatMessage>? messages,
    ActivityLocation? activityLocation,
    bool? conrimedLocation,
  }) {
    return MunicipalAdvisorState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      activityLocation: activityLocation ?? this.activityLocation,
      conrimedLocation: conrimedLocation ?? this.conrimedLocation,
    );
  }

  @override
  List<Object?> get props => [
        status,
        messages,
        activityLocation,
        conrimedLocation,
      ];
}
