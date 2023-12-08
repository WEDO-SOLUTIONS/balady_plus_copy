import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/offers/get_offers_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/offers/offers_item.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/offers/offers_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/use_cases/accept_offer.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/use_cases/get_offers.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/use_cases/reject_offer.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/request_details/request_replies_model.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/request_offers_page_params.dart';
import 'package:balady_plus/etmam_app/features/my_orders/presentation/blocs/request_details/request_details_bloc.dart';
import 'package:balady_plus/etmam_app/features/providers/providers_exports.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';

import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart'
    show ServerFailure;

import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show OrderAction, trans;

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show showDialogWidget;

import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show
        ActionParams,
        CancelOrderDialog,
        CancelOrderParams,
        GetOrdersParams,
        MoreDialog,
        OrderDetailsParams,
        RatingPageParams;

import '../../../../../../app/core/services/local/navigation_services.dart';
import '../../../../../../app/core/utils/common_functions.dart';
import '../../../../../../app/core/utils/constants/route_names.dart';
import '../../../../../../app/core/utils/enums/bloc_status.dart';

part 'offers_event.dart';

part 'offers_state.dart';

class RequestOfferBloc extends Bloc<OffersEvent, OffersState> {
  final RequestOffersPageParams args;
  final GetOffers _getOffers;
  final AcceptOffer _acceptOffer;
  final RejectOffer _rejectOffer;
  final GetProviderDetails _getProviderDetails;

  RequestOfferBloc({
    required this.args,
    required GetOffers getOffers,
    required AcceptOffer acceptOffer,
    required RejectOffer rejectOffer,
    required GetProviderDetails getProviderDetails,
  })  : _getOffers = getOffers,
        _acceptOffer = acceptOffer,
        _rejectOffer = rejectOffer,
        _getProviderDetails = getProviderDetails,
        super(OffersState(
            params: args,
            currentRequest: args.requestDetails.getRequestReplies().first,
            requestReplies: args.requestDetails.getRequestReplies())) {
    on<OffersEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetOffersEvent>(_getOffersHandler);
    on<AcceptOfferEvent>(_acceptOfferHandler);
    on<RejectOfferEvent>(_rejectOfferHandler);
    on<ChangeOfferServiceEvent>(_changeOfferServiceHandler);
    on<GetPRoviderDetailsEvent>(_getProviderDetailsHandler);

    add(GetOffersEvent(request: state.currentRequest));
  }

  Future<void> _getOffersHandler(GetOffersEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
      currentRequest: e.request ?? state.currentRequest,
    ));
    final failureOrSuccess = await _getOffers(GetOffersParams(
      page: 1,
      status:
          e.type ?? (e.request?.isAccepted == true ? "accepted" : "submitted"),
      requestId: e.request?.requestId ?? state.currentRequest?.requestId,
    ));

    failureOrSuccess.fold((failure) {
      BlocStatus? status = (failure as ServerFailure).errorCode != "2"
          ? BlocStatus.retry
          : BlocStatus.failure;

      String? error = (failure as ServerFailure).errorCode != "2"
          ? (failure as ServerFailure).errorMessage
          : "";

      emitter(state.copyWith(
        status: status,
        errorMessage: error,
        items: status == BlocStatus.failure ? [] : null,
        clearResponse: status == BlocStatus.failure,
      ));
    }, (r) {
      emitter(state.copyWith(
          status: BlocStatus.success,
          items: r.data?.result?.items,
          offersResponse: r.data?.result,
          errorMessage: ""));
    });
  }

  Future<void> _acceptOfferHandler(AcceptOfferEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failureOrSuccess = await _acceptOffer(e.id!);
    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (r) {
      RequestRepliesModel? request = state.currentRequest;
      request?.isAccepted = true;

      List<RequestRepliesModel>? requests = state.requestReplies?.map((elm) {
        print("rrrr ${elm.requestId}");
        print("rrrr ${request?.requestId}");
        if (elm.requestId == request?.requestId) {
          print("rrrr hh");

          elm.isAccepted = true;
        }
        return elm;
      }).toList();

      emitter(state.copyWith(
        status: BlocStatus.success,
        requestReplies: requests,
        currentRequest: request,
        errorMessage: "",
      ));

      add(GetOffersEvent(request: state.currentRequest, type: "accepted"));

      state.params?.requestDetailsBloc.add(RefreshPageHandlerEvent());
      if (r.data?.responseMessage != null) {
        CommonFunctions.showSuccess(r.data!.responseMessage!);
      }
    });
  }

  Future<void> _rejectOfferHandler(RejectOfferEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failureOrSuccess = await _rejectOffer(e.id!);
    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (r) {
      emitter(state.copyWith(status: BlocStatus.success, errorMessage: ""));
      add(GetOffersEvent(request: state.currentRequest));
      if (r.data?.responseMessage != null) {
        CommonFunctions.showSuccess(r.data!.responseMessage!);
      }
    });
  }

  Future<void> _changeOfferServiceHandler(
      ChangeOfferServiceEvent e, Emitter emitter) async {
    emitter(state.copyWith(currentRequest: e.request));
  }

  Future<void> _getProviderDetailsHandler(
      GetPRoviderDetailsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getProviderDetails(e.params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
      ));

      // Navigate to Providers screen
      NavigationService.pushNamed(
          routeName: EtmamRoutesNames.providersDetails,
          args: success.data!.result!);
    });
  }
}
