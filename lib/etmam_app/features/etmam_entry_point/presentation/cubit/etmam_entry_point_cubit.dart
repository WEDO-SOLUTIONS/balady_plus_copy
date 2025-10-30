import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart';
import 'package:balady_plus/etmam_app/core/services/local/use_case.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;

import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/etmam_entry_point/etmam_entry_point_exports.dart'
    show
        GetProfile,
        SaveProfile,
        CheckProfile,
        UpdateProfile,
        UpdateDeviceToken,
        GetForceVersion;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CityItem, showUpdateAppPopUpWidget;
import 'package:balady_plus/etmam_app/features/etmam_entry_point/domain/entities/create_profile_params.dart';
import 'package:balady_plus/etmam_app/features/etmam_entry_point/domain/entities/profile.dart';
import 'package:balady_plus/etmam_app/features/etmam_entry_point/domain/entities/update_profile_params.dart';
import 'package:balady_plus/etmam_app/features/etmam_entry_point/domain/use_cases/create_profile.dart';

import '../../../../../app/core/dependency_injection/injection_container.dart';
import '../../../on_boarding_cities/presentation/blocs/city_bloc.dart';

part 'etmam_entry_point_state.dart';

class EtmamEntryPointCubit extends Cubit<EtmamEntryPointState> {
  final GetProfile _getProfile;
  final SaveProfile _saveProfile;
  final CheckProfile _checkProfile;
  final CreateProfile _createProfile;
  final UpdateProfile _updateProfile;
  final UpdateDeviceToken _updateDeviceToken;

  final GetForceVersion _getForceVersion;
  String classificationId = "municipal";

  EtmamEntryPointCubit({
    required GetProfile getProfile,
    required SaveProfile saveProfile,
    required CheckProfile checkProfile,
    required CreateProfile createProfile,
    required UpdateProfile updateProfile,
    required UpdateDeviceToken updateDeviceToken,
    required GetForceVersion forceVersion,
  })  : _getProfile = getProfile,
        _saveProfile = saveProfile,
        _checkProfile = checkProfile,
        _createProfile = createProfile,
        _updateProfile = updateProfile,
        _updateDeviceToken = updateDeviceToken,
        _getForceVersion = forceVersion,
        super(const EtmamEntryPointState()) {
    onLoadingApp();
  }

  void changeServiceType({required String classificationId}) {
    this.classificationId = classificationId;
  }

  bool get isLifeStyle => classificationId == "life-style";

  Future<void> onLoadingApp() async {
    setTheme();
    emit(state.copyWith(blocStatus: BlocStatus.loading));
    final failureOrSuccess = await _checkProfile(NoParams());
    failureOrSuccess.fold((failure) {}, (profile) {
      emit(state.copyWith(
        blocStatus: BlocStatus.success,
        profile: profile,
        errorMessage: "",
      ));
      // refreshProfile();
    });

    //checkVersion();
  }

  Future<void> onLogin() async {
    emit(state.copyWith(
      blocStatus: BlocStatus.loading,
    ));

    final failureOrSuccessForProfile = await _getProfile(NoParams());
    await failureOrSuccessForProfile.fold((failure) async {
      ServerFailure serverFailure = (failure as ServerFailure);

      final failureOrSuccessForProfile =
          await _createProfile(CraeteProfileParams());

      failureOrSuccessForProfile.fold((failure) async {
        ServerFailure serverFailure = (failure as ServerFailure);
        sl<EntryPointCubit>().autoLogout();
        emit(EtmamEntryPointState(
            blocStatus: BlocStatus.failure,
            errorMessage: trans("errors_server_error_1")));
      }, (success) async {
        ///

        final failureOrSuccessForProfile = await _getProfile(NoParams());
        await failureOrSuccessForProfile.fold((failure) async {
          ServerFailure serverFailure = (failure as ServerFailure);
          sl<EntryPointCubit>().autoLogout();
          emit(EtmamEntryPointState(
              blocStatus: BlocStatus.failure,
              errorMessage: trans("errors_server_error_1")));
        }, (success) async {
          final failureOrSuccess = await _saveProfile(success.data!.result!);
          if (failureOrSuccess.isRight()) {
            emit(state.copyWith(
              blocStatus: BlocStatus.success,
              profile: success.data!.result!,
              errorMessage: "",
            ));
          }
          _updateDeviceToken(NoParams());
          sl<CityBloc>().updateCurrentCity(CityItem(
              id: success.data!.result!.cityId,
              name: success.data!.result!.cityName));
        });
      });
    }, (success) async {
      final failureOrSuccess = await _saveProfile(success.data!.result!);

      if (failureOrSuccess.isRight()) {
        emit(state.copyWith(
          blocStatus: BlocStatus.success,
          profile: success.data!.result!,
          errorMessage: "",
        ));
      }
      await _updateProfile(UpdateProfileParams(
          cityId: CommonProperties.cityId,
          langId: success.data?.result?.langId ?? "ar",
          name: success.data?.result?.type?.name ?? "Main Profile"));

      _updateDeviceToken(NoParams());
      if (success.data!.result!.cityId != null &&
          success.data!.result!.cityId!.isNotEmpty) {
        if (CommonProperties.cityItem == null ||
            success.data!.result!.cityId! == CommonProperties.cityItem?.id)
          sl<CityBloc>().updateCurrentCity(CityItem(
              id: success.data!.result!.cityId,
              name: success.data!.result!.cityName));
      }
    });
  }

  Future<void> setTheme() async {
    emit(state.copyWith(
      blocStatus: BlocStatus.loading,
    ));
    AppColorsTheme.setTheme(CommonProperties.cityId);
    emit(state.copyWith(
      blocStatus: BlocStatus.success,
    ));
  }

  Future<void> updateCity(CityItem city) async {
    final failOrSuccess = await _updateProfile(UpdateProfileParams(
        cityId: city.id!,
        langId: state.profile?.langId ?? "ar",
        name: state.profile?.type?.name ?? "Main Profile"));

    failOrSuccess.fold((l) {}, (r) {
      sl<CityBloc>().updateCurrentCity(city);
    });
  }

  Future<void> refreshProfile() async {
    final failureOrSuccessForProfile = await _getProfile(NoParams());
    await failureOrSuccessForProfile.fold((failure) async {}, (success) async {
      final failureOrSuccess = await _saveProfile(success.data!.result!);
      if (failureOrSuccess.isRight()) {
        emit(state.copyWith(
          profile: success.data!.result!,
        ));
        _saveProfile(success.data!.result!);
      }
    });
  }

  Future<void> checkVersion() async {
    await Future.delayed(Duration(seconds: 7));
    final failureOrSuccessForProfile = await _getForceVersion(NoParams());
    await failureOrSuccessForProfile.fold((failure) async {}, (success) async {
      print("SUCCCCCCCCESSSSSS ${success}");
      // if (success)
      //   showUpdateAppPopUpWidget(
      //       NavigationService.navigatorKey.currentContext!);
    });
  }
}
