import 'package:flutter/material.dart';
import 'package:smart_advisor/app/core/services/services_exports.dart';
import 'package:smart_advisor/app/core/utils/extensions/context_conversion.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';
import 'package:smart_advisor/app/features/self_rating/presentation/pages/result_page.dart'
    as resultPage;

import '../../data/models/rating_items_response.dart';
import '../../domain/entities/submit_rating_request.dart';
import '../../domain/use_cases/get_rating_items.dart';
import '../../domain/use_cases/submit_self_rating.dart';
import '/app/core/dependency_injection/injection_container.dart';
import '/app/core/errors/failures.dart';
import '/app/core/utils/enums/bloc_status.dart';
import '/app/features/select_activity/domain/entities/activity_details_page_params.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'rating_event.dart';

part 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final GetSelfRatingsItems _getSelfRatingsItems;
  final SubmitSelfRatingUC _submitSelfRatingUC;
  final ActivityDetailsPageParams args;
  RatingBloc({required this.args})
      : _getSelfRatingsItems = GetSelfRatingsItems(repository: sl()),
        _submitSelfRatingUC = SubmitSelfRatingUC(repository: sl()),
        super(RatingState()) {
    on<GetRatings>(getRatingsItems);
    on<SubmitRatings>(submitRatingsItems);
    on<ChangeItemRating>(changeRatingItem);
    on<UpdateItemsRatings>(updateItemsRatingsHandler);
    add(const GetRatings());
  }

  void updateItemsRatingsHandler(UpdateItemsRatings event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));
    Map<String, List<RatingItemsResponseItem>>? sortedItems = state.sortedItems;
    List<RatingItemsResponseItem> items = event.items;
    items = items.map((e) {
      e.isSaved = true;
      return e;
    }).toList();
    sortedItems![event.key] = items;

    emit(state.copyWith(status: BlocStatus.success, sortedItems: sortedItems));
  }

  void changeRatingItem(ChangeItemRating event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));
    Map<String, List<RatingItemsResponseItem>>? sortedItems = state.sortedItems;
    sortedItems![event.i]?[event.j].isClausesValidated = event.ratnig;

    emit(state.copyWith(status: BlocStatus.success, sortedItems: sortedItems));
    print(sortedItems[event.i]?[event.j]);
  }

  void getRatingsItems(GetRatings event, Emitter emit) async {
    emit(state.copyWith(itemsStatus: BlocStatus.loading));

    final failureOrSuccess =
        await _getSelfRatingsItems(args.activityId?.id ?? 0);
    await failureOrSuccess.fold(
      (failure) async {
        print(failure);
        emit(state.copyWith(status: BlocStatus.closeLoading));
        emit(state.copyWith(
          itemsStatus: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      },
      (success) async {
        emit(state.copyWith(itemsStatus: BlocStatus.closeLoading));
        emit(state.copyWith(
            itemsStatus: BlocStatus.success,
            items: success,
            sortedItems: state.getRatingsItems(success)));
      },
    );
  }

  void submitRatingsItems(SubmitRatings event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    List<InspectionSubClausesList> list = [];

    state.sortedItems?.entries.forEach(((e) {
      e.value.forEach((r) {
        list.add(InspectionSubClausesList(
          clauseName: r.getClausesName(),
          clauseNo: r.clauseNo.toString(),
          commentForNonCompliance: "",
          inspectionTypeNo: r.inspectionTypeNo,
          subClauseName: r.subClauseName ?? "",
          subClauseNo: r.subClauseNo.toString(),
          complianceStatus: r.isClausesValidated,
        ));
      });
    }));

    final failureOrSuccess = await _submitSelfRatingUC(SubmitRatingRequest(
        selfEvaluationType: "Awareness",
        businessActivityId: (args.activityId?.id ?? 0).toString(),
        municipalityId: args.gisData?.municipalityId,
        subMunicipalityId: args.gisData?.subMunicipalityId,
        inspectionSubClausesList: list,
        licenseNumber: args?.licenseNo));
    await failureOrSuccess.fold(
      (failure) async {
        print(failure);
        emit(state.copyWith(status: BlocStatus.closeLoading));
        emit(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      },
      (success) async {
        emit(state.copyWith(status: BlocStatus.closeLoading));
        emit(state.copyWith(
          status: BlocStatus.success,
        ));

        NavigationService.navigatorKey.currentState!.push(MaterialPageRoute(
            builder: (ctx) => resultPage.ResultPage(
                value: success,
                nonCompliance:
                    list.where((e) => e.complianceStatus == 2).toList())));
      },
    );
  }
}
