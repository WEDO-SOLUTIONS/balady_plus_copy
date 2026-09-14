import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_card_entity.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_product_entity.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_products_param.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_statistics_entity.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_statistics_param.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/volunteering_statistics_entity.dart';
import 'package:balady_plus/app/features/dashboard/domain/use_cases/get_dashboard_card_products.dart';
import 'package:balady_plus/app/features/dashboard/domain/use_cases/get_dashboard_card_statistics.dart';
import 'package:balady_plus/app/features/dashboard/domain/use_cases/get_dashboard_cards.dart';
import 'package:balady_plus/app/features/dashboard/domain/use_cases/get_volunteering_statistics.dart';
import 'package:balady_plus/app/features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardCards getDashboardCards;
  final GetDashboardCardProducts getDashboardProducts;
  final GetDashboardCardStatistics getDashboardStatistics;
  final GetVolunteeringStatistics getVolunteeringStatistics;

  DashboardBloc({
    required this.getDashboardCards,
    required this.getDashboardProducts,
    required this.getDashboardStatistics,
    required this.getVolunteeringStatistics,
  }) : super(const DashboardState()) {
    on<DashboardEventInitial>((event, emit) async => await _getDashboardCards(emit, event.delegatorsCubit));
    on<DashboardLoadCardStatistics>(_getDashboardStatistics);
    on<DashboardLoadVolunteeringStatistics>((event, emit) async => await _getVolunteeringStatistics(emit));

    on<DashboardLoadStatistics>((event, emit) async {
      for (final card in state.cards) {
        add(DashboardLoadCardStatistics(card: card));
      }
    });

    on<DashboardOnProductsPressed>((event, emit) async {
      final card = event.card;
      emit(
        state.copyWith(
          cardsStates: {
            ...state.cardsStates,
            card: state.cardsStates[card]!.copyWith(productsStatus: BlocRequestStatus.submissionGetLoading),
          },
        ),
      );
      final failureOrSuccess = await getDashboardProducts(DashboardProductsParams(cardId: card.id));

      failureOrSuccess.fold(
        (failure) {
          emit(
            state.copyWith(
              cardsStates: {
                ...state.cardsStates,
                card: state.cardsStates[card]!.copyWith(productsStatus: BlocRequestStatus.submissionGetFailure),
              },
            ),
          );
        },
        (products) {
          emit(
            state.copyWith(
              cardsStates: {
                ...state.cardsStates,
                card: state.cardsStates[card]!.copyWith(
                  productsStatus: BlocRequestStatus.submissionGetSuccess,
                  products: products,
                ),
              },
            ),
          );
        },
      );
    });

    on<DashboardOnProductSelected>((event, emit) async {
      final card = event.card;
      emit(
        state.copyWith(
          cardsStates: {
            ...state.cardsStates,
            card: state.cardsStates[card]!.copyWith(
              statisticsStatuses: BlocRequestStatus.submissionGetLoading,
              selectedProduct: event.product,
            ),
          },
        ),
      );
      add(DashboardLoadCardStatistics(card: card, product: event.product));
    });

    on<DashboardRetry>((event, emit) async {
      if (state.status == BlocRequestStatus.submissionGetFailure) {
        add(DashboardEventInitial());
      } else {
        for (final card in state.cards) {
          if (state.cardsStates[card]!.statisticsStatuses == BlocRequestStatus.submissionGetFailure) {
            add(DashboardLoadCardStatistics(card: card, product: state.cardsStates[card]?.selectedProduct));
          } else if (state.cardsStates[card]!.productsStatus == BlocRequestStatus.submissionGetFailure) {
            add(DashboardOnProductsPressed(card: card));
          }
        }
      }
    });
  }

  Future<void> _getDashboardCards(Emitter<DashboardState> emit, DelegatorsCubit? delegatorsCubit) async {
    if (!CommonProperties.isLoggedInMunicipality) return;
    emit(state.copyWith(status: BlocRequestStatus.submissionGetLoading, delegatorsCubit: delegatorsCubit));
    final failureOrSuccess = await getDashboardCards(NoParams());

    failureOrSuccess.fold(
      (failure) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetFailure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ),
        );
      },
      (cards) {
        add(DashboardLoadStatistics());
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetSuccess,
            cards: cards,
            cardsStates: Map.fromEntries(cards.map((card) => MapEntry(card, const CardState()))),
            delegatorsCubit: delegatorsCubit,
          ),
        );
      },
    );
  }

  Future<void> _getDashboardStatistics(DashboardLoadCardStatistics event, Emitter<DashboardState> emit) async {
    final card = event.card;
    emit(
      state.copyWith(
        cardsStates: {
          ...state.cardsStates,
          card: state.cardsStates[card]!.copyWith(statisticsStatuses: BlocRequestStatus.submissionGetLoading),
        },
      ),
    );

    // Get the DelegatorsCubit from the state (stored during initialization)
    // This ensures we get the same instance that's being used in the UI
    final delegatorsCubit = state.delegatorsCubit;

    final unifiedNationalNumber = delegatorsCubit?.state.selectedDelegate?.unifiedNationalNumber;
    final identityNumber = delegatorsCubit?.state.selectedDelegate?.crNumber;

    debugPrint(
      (
        "DEBUG: Dashboard statistics - Selected delegator: ${delegatorsCubit?.state.selectedDelegate?.entityName}, Agent: ${delegatorsCubit?.state.selectedAgent?.grantorName}",
      ).toString(),
    );
    debugPrint(
      (
        "DEBUG: Dashboard statistics - Using unifiedNationalNumber: $unifiedNationalNumber, identityNumber: $identityNumber",
      ).toString(),
    );
    final failureOrSuccess = await getDashboardStatistics(
      DashboardStatisticsParams(
        unifiedNationalNumber: unifiedNationalNumber,
        identityNumber: identityNumber,
        mainCardId: event.card.id,
        productId: event.product?.id,
      ),
    );

    failureOrSuccess.fold(
      (failure) {
        emit(
          state.copyWith(
            cardsStates: {
              ...state.cardsStates,
              card: state.cardsStates[card]!.copyWith(statisticsStatuses: BlocRequestStatus.submissionGetFailure),
            },
          ),
        );
      },
      (statistics) {
        emit(
          state.copyWith(
            cardsStates: {
              ...state.cardsStates,
              card: state.cardsStates[card]!.copyWith(
                statisticsStatuses: BlocRequestStatus.submissionGetSuccess,
                statistics: statistics,
              ),
            },
          ),
        );
      },
    );
  }

  Future<void> _getVolunteeringStatistics(Emitter<DashboardState> emit) {
    emit(LoadingVolunteeringStatisticsState());
    return getVolunteeringStatistics(NoParams()).then((failureOrSuccess) {
      failureOrSuccess.fold(
        (failure) => emit(const SuccessVolunteeringStatisticsState(volunteeringStatistics: null)),
        (statistics) => emit(SuccessVolunteeringStatisticsState(volunteeringStatistics: statistics)),
      );
    });
  }
}
