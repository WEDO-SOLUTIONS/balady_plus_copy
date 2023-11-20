import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../../core/utils/nullable.dart';

import '../../data/models/permit_license_response_model.dart';
import '../../domain/entities/permit_licenses_requests_params.dart';
import '../../domain/use_case/apply_permit_group.dart';
import '../../domain/use_case/get_groups_items.dart';
import '../../domain/use_case/get_license_permits.dart';
import '../../domain/use_case/get_permit_attachments.dart';
import '../../domain/use_case/get_poster_types.dart';
import '../../domain/use_case/save_poster.dart';
import '../pages/steps/step1_page.dart';
import '../pages/steps/step2_page.dart';
import '../pages/steps/step3_page.dart';

part 'posters_license_event.dart';
part 'posters_license_state.dart';

class PostersLicenseBloc
    extends Bloc<PostersLicenseEvent, PostersLicenseState> {
  PageController controller = PageController();
  ApplyPermitLicenseGroup _applyPermitLicenseGroup;
  GetGroupItems _getGroupItems;
  GetLicensePermits _getLicensePermits;
  GetAttachmentTypes _getAttachmentTypes;
  GetPermitPosterTypes _getPermitPosterTypes;
  SavePoster _savePoster;

  PostersLicenseBloc()
      : _applyPermitLicenseGroup = ApplyPermitLicenseGroup(repository: sl()),
        _getGroupItems = GetGroupItems(repository: sl()),
        _getLicensePermits = GetLicensePermits(repository: sl()),
        _getAttachmentTypes = GetAttachmentTypes(repository: sl()),
        _getPermitPosterTypes = GetPermitPosterTypes(repository: sl()),
        _savePoster = SavePoster(repository: sl()),
        super(const PostersLicenseState()) {
    on<GoToNextPageEvent>(_goToNextPageHandler);
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);
    on<GetLicensePermitsEvents>(_getLicensePermitsHandler);

    on<ChangePermitStartDate>(_updateStartDateHandler);

    on<ChangePermitDurationEvent>(_updateDurationHandler);
  }

  Future<void> _getLicensePermitsHandler(
      GetLicensePermitsEvents e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failOrSuccess = await _getLicensePermits(PermitLicenseRequestParams(
        page: 0,
        size: 20,
        crNumber: CommonProperties.selectedDelegator?.crNumber,
        groupId: "1042"));

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
          status: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) {
      emitter(state.copyWith(
        permitsLiceses: r.result,
        status: BlocStatus.success,
      ));
    });
  }

  Future<void> _goToNextPageHandler(
      GoToNextPageEvent e, Emitter emitter) async {
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

  Future<void> _updateStartDateHandler(
      ChangePermitStartDate e, Emitter emitter) async {
    emitter(state.copyWith(startDate: e.date));
  }

  Future<void> _updateDurationHandler(
      ChangePermitDurationEvent e, Emitter emitter) async {
    emitter(state.copyWith(duration: e.value));
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
