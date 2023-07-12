part of 'municipal_advisor_bloc.dart';

class MunicipalAdvisorState extends Equatable {
  final BlocRequestStatus status;
  final List<ChatMessage> messages;
  final ActivityLocation? activityLocation;
  final List<IsicActivityEntity> isicActivities;
  final IsicActivityEntity? selectedIsicActivity;
  final List<IsicActivityEntity> isicSubActivities;
  final IsicActivityEntity? selectedIsicSubActivity;
  final ActivityDetailsEntity? activityDetails;
  final num? selectedArea;
  final bool changingInfo;
  final MunicipalAdvisorEvent? lastEvent;
  final String? errorMessage;

  const MunicipalAdvisorState({
    this.status = BlocRequestStatus.initial,
    this.messages = const <ChatMessage>[],
    this.activityLocation,
    this.isicActivities = const <IsicActivityEntity>[],
    this.selectedIsicActivity,
    this.isicSubActivities = const <IsicActivityEntity>[],
    this.selectedIsicSubActivity,
    this.activityDetails,
    this.selectedArea,
    this.changingInfo = false,
    this.lastEvent,
    this.errorMessage,
  });

  String get error => errorMessage ?? '';

  MunicipalAdvisorState copyWith({
    BlocRequestStatus? status,
    List<ChatMessage>? messages,
    ActivityLocation? activityLocation,
    List<IsicActivityEntity>? isicActivities,
    IsicActivityEntity? selectedIsicActivity,
    List<IsicActivityEntity>? isicSubActivities,
    IsicActivityEntity? selectedIsicSubActivity,
    ActivityDetailsEntity? activityDetails,
    num? selectedArea,
    bool? changingInfo,
    MunicipalAdvisorEvent? lastEvent,
    String? errorMessage,
  }) {
    return MunicipalAdvisorState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      activityLocation: activityLocation ?? this.activityLocation,
      isicActivities: isicActivities ?? this.isicActivities,
      selectedIsicActivity: selectedIsicActivity ?? this.selectedIsicActivity,
      isicSubActivities: isicSubActivities ?? this.isicSubActivities,
      selectedIsicSubActivity:
          selectedIsicSubActivity ?? this.selectedIsicSubActivity,
      activityDetails: activityDetails ?? this.activityDetails,
      selectedArea: selectedArea ?? this.selectedArea,
      changingInfo: changingInfo ?? this.changingInfo,
      lastEvent: lastEvent ?? this.lastEvent,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        messages,
        activityLocation,
        isicActivities,
        selectedIsicActivity,
        isicSubActivities,
        selectedIsicSubActivity,
        activityDetails,
        selectedArea,
        changingInfo,
        lastEvent,
        errorMessage,
      ];
}
