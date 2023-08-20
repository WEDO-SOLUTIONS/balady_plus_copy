import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart';
import 'package:balady_plus/app/features/weather/domain/usecases/get_weather_info.dart';
import 'package:balady_plus/app/features/weather/weather_exports.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/errors/errors_exports.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeatherInfo _getWeatherInfo;
  final GetGISData _getGISData;
  WeatherBloc({
    required GetWeatherInfo getWeatherInfo,
  })  : _getWeatherInfo = getWeatherInfo,
        _getGISData = GetGISData(repository: sl()),
        super(WeatherState(gisResponse: CommonProperties.userLocationGIS)) {
    on<GetWeatherForLocation>(_getAllWeatherInfo);
    on<RefreshWeatherForLocation>(_refreshWeatherForLocation);

    on<ChangeIndexEvent>(
        (event, emit) => emit(state.copyWith(selectedTile: event.index)));
  }

  Future<void> _getAllWeatherInfo(
      GetWeatherForLocation e, Emitter emitter) async {
    //   if (state.allWeatherInfoStatus == BlocStatus.success &&
    //     state.showLocationError == false) return;

    print("_getAllWeatherInfo");

    emitter(state.copyWith(
      allWeatherInfoStatus: BlocStatus.loading,
    ));

    GISParams? location = CommonProperties.userLocation;

    if (location == null || CommonProperties.userLocationGIS == null) {
      WeatherParams params =
          e.params.copyWith(latitude: location?.y, longitude: location?.x);
      final failureOrSuccess = await _getGISData(
          GISParams(x: params.longitude!, y: params.latitude!));
      await failureOrSuccess.fold((failure) async {
        emitter(state.copyWith(
          allWeatherInfoStatus: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));

        final failureOrSuccess = await _getWeatherInfo(params);
        failureOrSuccess.fold((failure) {
          print("failure: weather $failure");
          emitter(state.copyWith(
            allWeatherInfoStatus: BlocStatus.failure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ));
        }, (success) {
          print("weather entity: $success");
          emitter(state.copyWith(
            allWeatherInfoStatus: BlocStatus.success,
            allWeatherInfo: success,
            gisResponse: CommonProperties.userLocationGIS,
            errorMessage: "",
          ));
        });
      }, (gisSuccess) async {
        final failureOrSuccess = await _getWeatherInfo(params);
        failureOrSuccess.fold((failure) {
          print("failure: weather $failure");
          emitter(state.copyWith(
            allWeatherInfoStatus: BlocStatus.failure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ));
        }, (success) {
          print("weather entity: $success");
          emitter(state.copyWith(
            allWeatherInfoStatus: BlocStatus.success,
            gisResponse: gisSuccess,
            allWeatherInfo: success,
            errorMessage: "",
          ));
        });
      });
    } else {
      print("_getAllWeatherInfo 2");
      WeatherParams params =
          e.params.copyWith(latitude: location.y, longitude: location.x);

      final failureOrSuccess = await _getWeatherInfo(params);
      failureOrSuccess.fold((failure) {
        print("failure: weather $failure");
        emitter(state.copyWith(
          allWeatherInfoStatus: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      }, (success) {
        print("weather entity: $success");
        emitter(state.copyWith(
          allWeatherInfoStatus: BlocStatus.success,
          allWeatherInfo: success,
          gisResponse: CommonProperties.userLocationGIS,
          location: location,
          showLocationError: false,
          errorMessage: "",
        ));
      });
    }

/*  ;*/
  }

  Future<void> _refreshWeatherForLocation(
      RefreshWeatherForLocation e, Emitter emitter) async {
    GISParams? location = CommonProperties.userLocation;

    WeatherParams params =
        e.params.copyWith(latitude: location?.y, longitude: location?.x);

    final failureOrSuccess = await _getWeatherInfo(params);
    failureOrSuccess.fold((failure) {
      print("failure: weather $failure");
      emitter(state.copyWith());
    }, (success) {
      print("weather entity: $success");
      emitter(state.copyWith(
        allWeatherInfoStatus: BlocStatus.success,
        allWeatherInfo: success,
        errorMessage: "",
      ));
    });

/*  ;*/
  }
}
