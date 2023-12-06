import 'package:balady_plus/app/features/ekram/ekram_exports.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/services/local/use_case.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';

part 'ekram_add_deceased_event.dart';
part 'ekram_add_deceased_state.dart';

class EkramAddDeceasedBloc
    extends Bloc<EkramAddDeceasedEvent, EkramAddDeceasedState> {
  final GetCities _getCities;
  final GetNationalities _getNationalities;
  final GetLookUp _getLookUp;

  EkramAddDeceasedBloc(
      {required GetCities getCities,
      required GetNationalities getNationalities,
      required GetLookUp getLookUp,
      required AddDeceasedDialogParams params})
      : _getCities = getCities,
        _getNationalities = getNationalities,
        _getLookUp = getLookUp,
        super(EkramAddDeceasedState(
            cities: params.cities,
            nationalities: params.nationalities,
            data: params.data)) {
    on<EkramAddDeceasedEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<ChangeFullNameEvent>(_changeFullNameHanlder);
    on<ChangeGenderEvent>(_changeGenderHanlder);
    on<ChangeReligionEvent>(_changeReligionHanlder);
    on<ChangeNationalityEvent>(_changeNationalityHanlder);
    on<ChangeBurialDestinationEvent>(_changeBurialDestinationHanlder);
    on<ChangeBurialDestinationCityEvent>(_changeBurialDestinationCityHanlder);
    on<ChangeIsNeedSpecialTransferEvent>(_changeIsNeedSpecialTransferHanlder);
    on<ChangeNeedSpecialTransferEvent>(_changeNeedSpecialTransferHandler);
    on<ChangeNeedSpecialTransferReasonEvent>(
        _changeNeedSpecialTransferReasonHandler);
  }

  Future<void> _changeFullNameHanlder(
      ChangeFullNameEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      data: state.data.copyWith(name: e.text),
    ));
  }

  Future<void> _changeGenderHanlder(
      ChangeGenderEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      data: state.data.copyWith(genderId: e.item),
    ));
  }

  Future<void> _changeReligionHanlder(
      ChangeReligionEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      data: state.data.copyWith(muslimReligion: e.item),
    ));
    print(state.data.muslimReligion);
  }

  Future<void> _changeNationalityHanlder(
      ChangeNationalityEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      data: state.data.copyWith(nationalityId: e.item),
    ));
  }

  Future<void> _changeBurialDestinationHanlder(
      ChangeBurialDestinationEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        data: state.data.copyWith(multipleCityRequest: !e.sameCity!)));
  }

  Future<void> _changeBurialDestinationCityHanlder(
      ChangeBurialDestinationCityEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      data: state.data.copyWith(burialCityId: e.item),
    ));
  }

  Future<void> _changeIsNeedSpecialTransferHanlder(
      ChangeIsNeedSpecialTransferEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        data: state.data.copyWith(specialTransferNeeded: e.isNeeded)));
  }

  Future<void> _changeNeedSpecialTransferHandler(
      ChangeNeedSpecialTransferEvent e, Emitter emitter) async {
    print(state?.data.specialTransferReasonId);
    emitter(state.copyWith(
      data: state.data.copyWith(specialTransferReasonId: e.item),
    ));
  }

  Future<void> _changeNeedSpecialTransferReasonHandler(
      ChangeNeedSpecialTransferReasonEvent e, Emitter emitter) async {
    print("FFFF");
    emitter(state.copyWith(
      data: state.data.copyWith(specialTransferOtherReason: e.text),
    ));
  }

  Future<List<LookUpItem>?> getSpecialReasonsLookUp() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getLookUp(30200);
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      emit(state.copyWith(
        status: BlocStatus.success,
        specialNeeds: success.data?.result,
        errorMessage: "",
      ));
      return success.data?.result;
    });
  }

  Future<List<LookUpItem>?> getCitiesHandler() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getCities(NoParams());
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      emit(state.copyWith(
        status: BlocStatus.success,
        cities: success.data?.result,
        errorMessage: "",
      ));
      return success.data?.result;
    });
  }

  Future<List<LookUpItem>?> getNationalitiesHandler() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getNationalities(NoParams());

    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      emit(state.copyWith(
        status: BlocStatus.success,
        nationalities: success.data?.result,
        errorMessage: "",
      ));
      return success.data?.result;
    });
  }
}
