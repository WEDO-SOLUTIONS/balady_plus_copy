import 'package:balady_plus/app/features/services/services_exports.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'service_cards_state.dart';

class ServiceCardsCubit extends Cubit<ServiceCardsState> {
  ServiceCardsCubit(ServiceEntity service)
      : super(
          ServiceCardsState(
            service: service,
            selectedCard: service.cards.first,
          ),
        );

  void selectCard(ServiceCardEntity card) {
    emit(
      state.copyWith(
        selectedCard: card,
      ),
    );
  }

  void toggleWarning() {
    emit(
      state.copyWith(
        expandedWarning: !state.expandedWarning,
      ),
    );
  }
}
