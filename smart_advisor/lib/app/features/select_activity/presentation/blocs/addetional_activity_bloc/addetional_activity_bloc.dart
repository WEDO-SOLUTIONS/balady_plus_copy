import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../data/models/activity_item_model.dart';
import '/app/features/home/home_exports.dart';
import '/app/features/select_activity/domain/entities/activity_details_page_params.dart';
import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../../core/errors/errors_exports.dart' show ServerFailure;

import '../../../../../core/utils/utils_exports.dart' show BlocStatus;
import '../../../domain/entities/addetional_activites_response.dart';
import '../../../domain/use_cases/get_addetional_activites.dart';

part 'addetional_activity_event.dart';

part 'addetional_activity_state.dart';

class AddetionalActivityBloc
    extends Bloc<AddetionalActivityEvent, AddetionalActivityState> {
  final GetAddetionalActivitesUc _getAddetionalActivites;
  final ActivityDetailsPageParams args;

  AddetionalActivityBloc({required this.args})
      : _getAddetionalActivites = GetAddetionalActivitesUc(repository: sl()),
        super(const AddetionalActivityState()) {
    ///
    on<GetAddetionalActivites>((event, emit) async {
      emit(state.copyWith(addetionalActivitesStatus: BlocStatus.loading));

      final failureOrSuccess =
          await _getAddetionalActivites(args.activityId!.id.toString());
      await failureOrSuccess.fold(
        (failure) async {
          print(failure);
          emit(state.copyWith(
              addetionalActivitesStatus: BlocStatus.closeLoading));
          emit(state.copyWith(
            addetionalActivitesStatus: BlocStatus.failure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ));
        },
        (success) async {
          List<AddetionalActivityItem> res = success ?? [];

          res = success;
          try {
            res = await sortOriginalByCount(res);
          } catch (ex) {}
          emit(state.copyWith(
            addetionalActivitesStatus: BlocStatus.success,
            addetionalActivitesResponse: res,
          ));
        },
      );
    });
    on<ToggleAddetionalActivity>(getZonesHandler);
    add(const GetAddetionalActivites());
  }

  Future<List<AddetionalActivityItem>> sortOriginalByCount(
      List<AddetionalActivityItem> originalList) async {
    final String isicsDetails = await rootBundle.loadString(
        'packages/smart_advisor/smart_advisor_assets/files/Detailed_Count_Sorted.json');
    var data1 = await json.decode(isicsDetails);

    List<ActivityCount> detailsList = [];
    for (var item in data1) {
      detailsList.add(ActivityCount.fromJson(item));
    }

    final countMap = {for (var item in detailsList) item.id: item.count};

    // Sort the original list based on the count in countMap
    return originalList.toList()
      ..sort((a, b) {
        final countA =
            countMap[a.activityId] ?? 0; // Default to 0 if id is not found
        final countB = countMap[b.activityId] ?? 0;
        return countB.compareTo(countA); // Sort in descending order by count
      });
  }

  void getZonesHandler(ToggleAddetionalActivity event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    List<AddetionalActivityItem> addetionalActivitesResponse =
        state.addetionalActivitesResponse ?? [];

    bool isSelected =
        addetionalActivitesResponse[event.index].isSelected ?? false;
    addetionalActivitesResponse[event.index].isSelected = !isSelected;

    emit(state.copyWith(
        status: BlocStatus.success,
        addetionalActivitesResponse: addetionalActivitesResponse));
  }
}
