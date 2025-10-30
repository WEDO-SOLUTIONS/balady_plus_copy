import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart';
import 'package:balady_plus/etmam_app/core/services/services_exports.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/bidding_type/bidding_type_item.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/bidding_type/bidding_type_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/use_cases/find_by_request_type.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../app/core/utils/enums/bloc_status.dart';
import '../../../../../../app/features/_shared_feature_/data/entities/drop_down_item.dart';

part 'bidding_type_event.dart';
part 'bidding_type_state.dart';

class BiddingTypeBloc extends Bloc<BiddingTypeEvent, BiddingTypeState> {
  final FindByRequestType _findByRequestType;
  BiddingTypeBloc({required FindByRequestType findByRequestType})
      : _findByRequestType = findByRequestType,
        super(BiddingTypeState()) {
    on<BiddingTypeEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<FindByRequestTypeEvent>(_findByRequestTypeEventHandler);
    on<ChangeSubReleationSelection>(_changeSubReleationSelectionHandler);
    on<ChangeReleationSelectionEvent>(_changeReleationSelectionHandler);

    add(FindByRequestTypeEvent());
  }

  Future<void> _findByRequestTypeEventHandler(
      FindByRequestTypeEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failureOrSuccess = await _findByRequestType(NoParams());
    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        releationResponse: success.data?.result,
        releationResponseDropDowns: success.data?.result
            ?.map((e) => DropDownItem(id: e.id, name: e.name ?? ""))
            .toList(),
        errorMessage: "",
      ));
    });
  }

  Future<void> _changeSubReleationSelectionHandler(
      ChangeSubReleationSelection e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    BiddingTypeResponse? res = state.selectedResponse;
    res?.subRelations?[e.index].isSelected = e.isSelected;
    emitter(state.copyWith(status: BlocStatus.success, selectedResponse: res));
  }

  Future<void> _changeReleationSelectionHandler(
      ChangeReleationSelectionEvent e, Emitter emitter) async {
    e.item.subRelations = e.item.subRelations?.map((e) {
      e.isSelected = false;
      return e;
    }).toList();

    emitter(state.copyWith(selectedResponse: e.item));
  }
}
