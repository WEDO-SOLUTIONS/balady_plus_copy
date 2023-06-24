part of 'service_cards_cubit.dart';

class ServiceCardsState extends Equatable {
  final ServiceEntity service;
  final ServiceCardEntity? selectedCard;
  final bool expandedWarning;

  const ServiceCardsState({
    required this.service,
    this.selectedCard,
    this.expandedWarning = true,
  });

  ServiceCardsState copyWith({
    ServiceEntity? service,
    ServiceCardEntity? selectedCard,
    bool? expandedWarning,
  }) {
    return ServiceCardsState(
      service: service ?? this.service,
      selectedCard: selectedCard ?? this.selectedCard,
      expandedWarning: expandedWarning ?? this.expandedWarning,
    );
  }

  @override
  List<Object?> get props => [
        service,
        selectedCard,
        expandedWarning,
      ];
}
