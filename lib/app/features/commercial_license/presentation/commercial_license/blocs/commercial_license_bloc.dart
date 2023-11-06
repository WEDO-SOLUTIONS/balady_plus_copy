import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../../core/services/services_exports.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../vd/domain/entities/gis/gis_params.dart';
import '../../../../vd/domain/entities/gis/gis_response.dart';
import '../../../commercial_license_exports.dart';
import '../../../data/models/qr/apply_commercial_response_model.dart';
import '../../step11/bloc/cr_step11_attachment_data_cubit.dart';
import '../../step11/page/cr_step11_attachment_data.dart';
import '../../step12/page/cr_step12_calculator.dart';
import '../../step13/page/cr_step13_review.dart';

part 'commercial_license_event.dart';
part 'commercial_license_state.dart';

class CommercialLicenseBloc
    extends Bloc<CommercialLicenseEvent, CommercialLicenseState> {
  PageController controller = PageController();

  CommercialLicenseBloc() : super(const CommercialLicenseState()) {
    on<GoToNextPageEvent>(_goToNextPageHandler);
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);

    on<UpdateRequestFieldEvent>(_updateRequestIdHandler);
  }

  Future<void> goToCalucaltePage() async {
    if (state.status == BlocStatus.performing) return;
    int nextPage = 9;

    emit(state.copyWith(
      status: BlocStatus.performing,
    ));

    controller.jumpToPage(nextPage);

    emit(
        state.copyWith(status: BlocStatus.success, currentPageValue: nextPage));

    hideKeyboard();
  }

  Future<void> _goToNextPageHandler(
      GoToNextPageEvent e, Emitter emitter) async {
    //print("next page");
    print("DataLog ${state}");
    if (isLastPage()) {
    } else {
      if (state.status == BlocStatus.performing) return;
      int nextPage = state.currentPageValue + 1;

      emitter(state.copyWith(
        status: BlocStatus.performing,
      ));

      controller.jumpToPage(nextPage);

      emitter(state.copyWith(
          status: BlocStatus.success, currentPageValue: nextPage));
    }
    hideKeyboard();
  }

  Future<void> _goToPreviousPageHandler(
      GoToPreviousPageEvent e, Emitter emitter) async {
    if (state.currentPageValue == 0.0) {
      NavigationService.navigatorKey.currentState!.pop();
    } else {
      if (state.status == BlocStatus.performing) return;
      int prvoiusPage = state.currentPageValue - 1;
      emitter(state.copyWith(
        status: BlocStatus.performing,
      ));
      controller.jumpToPage(prvoiusPage);

      emitter(state.copyWith(
          status: BlocStatus.success, currentPageValue: prvoiusPage));
    }
    hideKeyboard();
  }

  bool isLastPage() {
    return state.currentPageValue == (state.pagesList.length - 1);
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> _updateRequestIdHandler(
      UpdateRequestFieldEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        requestId: e.requestId != null ? Nullable(e.requestId) : null,
        locationResponse: e.saveLocationResponse));
  }

  Future<void> updateQrData(
      {ApplyCommercialResponseModel? applyCommercialResponse}) async {
    print(applyCommercialResponse);
    emit(state.copyWith(status: BlocStatus.loading));

    emit(state.copyWith(
        applyCommercialResponse: applyCommercialResponse,
        status: BlocStatus.success));
  }

  Future<void> updateCalculatorData(
      {CrCalculateFeesResponse? crCalculateFeesResponse,
      String? selectedPeriod}) async {
    emit(state.copyWith(status: BlocStatus.loading));

    emit(state.copyWith(
        crCalculateFeesResponse: crCalculateFeesResponse,
        selectedPeriod: selectedPeriod,
        status: BlocStatus.success));
  }

  Future<void> updateGISData({GISResponse? gis}) async {
    emit(state.copyWith(status: BlocStatus.loading));

    emit(state.copyWith(gisResponse: gis, status: BlocStatus.success));
  }

  void initState({int? requestId}) {
    emit(state.copyWith(
      status: BlocStatus.initial,
      isDraft: requestId != null ? true : false,
      currentPageValue: 0,
      requestId: Nullable(requestId),
      pagesList: const [
        CRStep1ApplicantData(),
        CRStep2ActivityData(),
        CRStep3GeolocationData(),
        CRStep4ShopData(),
        CRStep5AttachmentData(),
        CRStep6EstablishmentData(),
        //  CRStep7EstablishmentContactData(),
        //  CRStep8EmployeeData(),
        CRStep9WorkTimes(),
        CRStep10AdditionalData(),
        CRStep11AttachmentData(),
        CRStep12CalculatorReview(),
        CRStep13Review(),
      ],
    ));
  }
}
