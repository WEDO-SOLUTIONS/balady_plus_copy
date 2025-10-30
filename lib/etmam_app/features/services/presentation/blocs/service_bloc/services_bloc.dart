import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/etmam_app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/core/services/services_exports.dart';
import 'package:balady_plus/etmam_app/core/utils/common_properties.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/route_name.dart';
import 'package:balady_plus/etmam_app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/etmam_app/core/utils/enums/page_type.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show
        ServiceItems,
        ServiceResponse,
        GetServicesProvidersByService,
        ServiceDetailsParams,
        GetServiceDetails,
        GetReleation,
        ServiceParams,
        RelationParams;
import 'package:balady_plus/etmam_app/features/submit_request/domain/entities/submit/submit_page_params.dart';
import 'package:balady_plus/etmam_app/features/submit_request/submit_request_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  GetServicesProvidersByService _getServicesProvidersByService;
  GetServiceDetails _getServiceDetails;
  GetReleation _getRelations;
  final String? orderId;
  final bool? changeProvider;
  final PageTypes? pageType;
  final ScrollController scrollController;
  final Function? callBack;

  ServicesBloc(
      {required ServiceResponse response,
      required GetServicesProvidersByService getServicesProvidersByService,
      required GetServiceDetails getServiceDetails,
      required GetReleation getRelations,
      required this.scrollController,
      this.callBack,
      this.changeProvider,
      this.pageType,
      this.orderId})
      : _getServicesProvidersByService = getServicesProvidersByService,
        _getServiceDetails = getServiceDetails,
        _getRelations = getRelations,
        super(ServicesState(
            items: response.items,
            totalItemCount: response.totalItemCount,
            totalPageCount: response.totalPageCount,
            subServiceId: response.serviceId,
            subServiceName: response.serviceName,
            nextPageIndex: 2)) {
    on<ServicesEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetServiceDetailsEvent>(_getGetServiceDetailsHandler);
    on<GetRelationsEvent>(_getRelationsHandler);
    on<LoadMoreServices>(_loadMoreOrdersHandler);

    on<GetServicesEvent>(_getServicesHandler);
    scrollController.addListener(_scrollListener);
  }

  Future<void> _getGetServiceDetailsHandler(
      GetServiceDetailsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getServiceDetails(e.params);

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

      NavigationService.pushNamed(
          routeName: EtmamRoutesNames.serviceProvidersDetails,
          args: success.data?.result);
    });
  }

  Future<void> _getRelationsHandler(
      GetRelationsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getRelations(e.params);

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

      if (success.data?.result?.subRelations?.isNotEmpty ?? false) {
        NavigationService.pushNamed(
            routeName: EtmamRoutesNames.relationsList,
            args: RelationPageParam(
                relationResponse: success.data?.result,
                serviceProviderId: e.params.serviceProviderId,
                serviceProviderName: e.params.serviceProviderName,
                subServiceId: state.subServiceId,
                inputsRequired: success.data?.result?.inputsRequired,
                subServiceName: state.subServiceName,
                changeProvider: changeProvider,
                pageType: pageType,
                orderId: orderId,
                callBack: callBack));
      } else {
        NavigationService.pushNamed(
            routeName: EtmamRoutesNames.orderInfo,
            args: SubmitPageParams(
                serviceProviderId: e.params.serviceProviderId,
                serviceProviderName: e.params.serviceProviderName,
                subServiceId: state.subServiceId,
                relationId: success.data?.result?.id,
                inputsRequired: success.data?.result?.inputsRequired,
                subServiceName: state.subServiceName,
                subRelations: success.data?.result?.subRelations,
                changeProvider: changeProvider,
                orderId: orderId,
                callBack: callBack));
      }
    });
  }

  Future<void> _getServicesHandler(GetServicesEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading, name: e.name));
    print("BBBBBBBB");
    final failureOrSuccess = await _getServicesProvidersByService(ServiceParams(
        cityId: CommonProperties.cityId,
        subServiceId: state.subServiceId ?? "",
        subServiceName: state.subServiceName ?? "",
        pageIndex: "1",
        name: e.name));

    failureOrSuccess.fold((failure) {
      print("failure1111 $failure");
      BlocStatus? status = (failure as ServerFailure).errorCode != "2"
          ? BlocStatus.failure
          : BlocStatus.success;

      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: status == BlocStatus.success
            ? ""
            : (failure as ServerFailure).errorMessage,
        items: status == BlocStatus.success ? [] : state.items,
        totalItemCount: 0,
        totalPageCount: 0,
        nextPageIndex: 2,
      ));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        items: success.data?.result?.items,
        totalItemCount: success.data?.result?.totalItemCount,
        totalPageCount: success.data?.result?.totalPageCount,
        nextPageIndex: 2,
        errorMessage: "",
      ));
    });
  }

  Future<void> _loadMoreOrdersHandler(
      LoadMoreServices e, Emitter emitter) async {
    if (state.nextPageIndex > (state.totalPageCount ?? 0)) {
      emitter(state.copyWith(status: BlocStatus.success));
      return;
    }

    emitter(state.copyWith(status: BlocStatus.loadMore));

    final failureOrSuccess = await _getServicesProvidersByService(ServiceParams(
        cityId: CommonProperties.cityId,
        name: state.name,
        subServiceId: state.subServiceId ?? "",
        subServiceName: state.subServiceName ?? "",
        pageIndex: state.nextPageIndex.toString()));

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      List<ServiceItems> newItems = success.data?.result?.items ?? [];
      List<ServiceItems> oldItems = state.items ?? [];

      List<ServiceItems> newList = [];
      for (int i = 0; i < oldItems.length; i++) {
        newList.add(oldItems[i]);
      }
      for (int i = 0; i < newItems.length; i++) {
        newList.add(newItems[i]);
      }

      emitter(state.copyWith(
        status: BlocStatus.success,
        items: newList,
        totalItemCount: success.data?.result?.totalItemCount,
        totalPageCount: success.data?.result?.totalPageCount,
        nextPageIndex: state.nextPageIndex + 1,
        errorMessage: "",
      ));
    });
  }

  void _scrollListener() {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      add(LoadMoreServices());
    }
  }
}
