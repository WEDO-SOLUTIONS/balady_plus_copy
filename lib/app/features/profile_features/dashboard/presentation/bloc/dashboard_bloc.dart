import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/errors_exports.dart' show ServerFailure;
import '../../../../../core/services/services_exports.dart' show NoParams;
import '../../../../../core/utils/utils_exports.dart'
    show BlocRequestStatus, CommonProperties, Nullable;
import '../../dashboard_exports.dart'
    show
        DashboardCardEntity,
        DashboardProductEntity,
        DashboardProductsParams,
        DashboardStatisticsEntity,
        DashboardStatisticsParams,
        GetDashboardCardProducts,
        GetDashboardCardStatistics,
        GetDashboardCards;

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardCards getDashboardCards;
  final GetDashboardCardProducts getDashboardProducts;
  final GetDashboardCardStatistics getDashboardStatistics;

  DashboardBloc({
    required this.getDashboardCards,
    required this.getDashboardProducts,
    required this.getDashboardStatistics,
  }) : super(const DashboardState()) {
    on<DashboardEventInitial>(
      (event, emit) async {
        if (!CommonProperties.isLoggedInMunicipality) return;
        emit(
          state.copyWith(status: BlocRequestStatus.submissionGetLoading),
        );
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
                cardsStates: Map.fromEntries(
                  cards.map((card) => MapEntry(card, const CardState())),
                ),
              ),
            );
          },
        );
      },
    );

    on<DashboardLoadStatistics>(
      (event, emit) async {
        for (final card in state.cards) {
          add(DashboardLoadCardStatistics(card: card));
        }
      },
    );

    on<DashboardLoadCardStatistics>(
      (event, emit) async {
        final card = event.card;
        emit(
          state.copyWith(
            cardsStates: {
              ...state.cardsStates,
              card: state.cardsStates[card]!.copyWith(
                statisticsStatuses: BlocRequestStatus.submissionGetLoading,
              ),
            },
          ),
        );
        final unifiedNationalNumber =
            CommonProperties.selectedDelegator?.unifiedNationalNumber;
        final identityNumber = CommonProperties.selectedDelegator?.crNumber;
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
                  card: state.cardsStates[card]!.copyWith(
                    statisticsStatuses: BlocRequestStatus.submissionGetFailure,
                  ),
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
      },
    );

    on<DashboardOnProductsPressed>(
      (event, emit) async {
        final card = event.card;
        emit(
          state.copyWith(
            cardsStates: {
              ...state.cardsStates,
              card: state.cardsStates[card]!.copyWith(
                productsStatus: BlocRequestStatus.submissionGetLoading,
              ),
            },
          ),
        );
        final failureOrSuccess = await getDashboardProducts(
          DashboardProductsParams(cardId: card.id),
        );

        failureOrSuccess.fold(
          (failure) {
            emit(
              state.copyWith(
                cardsStates: {
                  ...state.cardsStates,
                  card: state.cardsStates[card]!.copyWith(
                    productsStatus: BlocRequestStatus.submissionGetFailure,
                  ),
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
      },
    );

    on<DashboardOnProductSelected>(
      (event, emit) async {
        final card = event.card;
        emit(
          state.copyWith(
            cardsStates: {
              ...state.cardsStates,
              card: state.cardsStates[card]!.copyWith(
                statisticsStatuses: BlocRequestStatus.submissionGetLoading,
                selectedProduct: Nullable(event.product),
              ),
            },
          ),
        );
        add(DashboardLoadCardStatistics(card: card, product: event.product));
      },
    );

    on<DashboardRetry>(
      (event, emit) async {
        if (state.status == BlocRequestStatus.submissionGetFailure) {
          add(DashboardEventInitial());
        } else {
          for (final card in state.cards) {
            if (state.cardsStates[card]!.statisticsStatuses ==
                BlocRequestStatus.submissionGetFailure) {
              add(DashboardLoadCardStatistics(
                  card: card,
                  product: state.cardsStates[card]?.selectedProduct));
            } else if (state.cardsStates[card]!.productsStatus ==
                BlocRequestStatus.submissionGetFailure) {
              add(DashboardOnProductsPressed(card: card));
            }
          }
        }
      },
    );
  }
}
