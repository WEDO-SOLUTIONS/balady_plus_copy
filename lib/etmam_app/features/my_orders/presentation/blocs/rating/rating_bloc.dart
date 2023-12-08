import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart';
import 'package:balady_plus/etmam_app/core/services/services_exports.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/models/success_screen_args.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/use_cases/get_rating_items.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/use_cases/submit_rating.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/use_cases/submit_rating_params.dart';
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../app/core/services/local/navigation_services.dart';
import '../../../../../../app/core/utils/constants/route_names.dart';
import '../../../../../../app/core/utils/enums/bloc_status.dart';

part 'rating_event.dart';
part 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final GetRatingItems _getRatingItems;
  final SubmitRating _submitRating;

  RatingBloc(
      {required GetRatingItems getRatingItems,
      required RatingPageParams args,
      required SubmitRating submitRating})
      : _submitRating = submitRating,
        _getRatingItems = getRatingItems,
        super(RatingState(args: args)) {
    on<RatingEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetRatingItemsEvent>(_getRatingItemsHandler);
    add(GetRatingItemsEvent());

    on<ChangeRateEvent>(_changeRatingHandler);
    on<SubmitRateEvent>(_submitRatingHandler);

    on<ChangeRatingComment>(_changeRatingCommentHandler);
    on<ValidateFormEvent>(_validateFormHandler);
  }

  Future<void> _getRatingItemsHandler(
      GetRatingItemsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getRatingItems(NoParams());

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.retry,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        items: success.data?.result,
        errorMessage: "",
      ));
    });
  }

  Future<void> _submitRatingHandler(SubmitRateEvent e, Emitter emitter) async {
    if (state.status == BlocStatus.loading) return;
    emitter(state.copyWith(status: BlocStatus.loading));
    SubmitRatingParams params = SubmitRatingParams(
        items: state.items,
        orderId: state.args?.orderId,
        review: state.comment);
    final failureOrSuccess = await _submitRating(params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        items: success.data?.result,
        errorMessage: "",
      ));

      NavigationService.navigatorKey.currentState
          ?.pushReplacementNamed(EtmamRoutesNames.successRoute,
              arguments: SuccessScreenArgs(
                  idNumber: "",
                  thanksMessage: trans("rating_success_message"),
                  icon: IconPath.successEvaluateOrderIcon,
                  type: PageTypes.evaluateOrder,
                  iconHeight: 176,
                  iconWidth: 176))
          .then((value) {
        if (state.args?.refresh != null) {
          state.args!.refresh!();
        }
      });
    });
  }

  Future<void> _changeRatingHandler(ChangeRateEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    List<RatingItem> items = state.items ?? [];
    items[e.index].value = e.rate;

    emitter(state.copyWith(status: BlocStatus.success, items: items));

    add(ValidateFormEvent());
  }

  Future<void> _changeRatingCommentHandler(
      ChangeRatingComment e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    emitter(state.copyWith(status: BlocStatus.success, comment: e.text));

    add(ValidateFormEvent());
  }

  Future<void> _validateFormHandler(
      ValidateFormEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    bool isValid = true;
    state.items?.forEach((element) {
      if (element.value == null) isValid = false;
    });
    /*  if (state.comment == null && (state.comment?.isEmpty ?? true)) {
      isValid = false;
    }*/

    emitter(state.copyWith(status: BlocStatus.success, isFormValid: isValid));
  }
}
