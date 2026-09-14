import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/location/domain/entities/gis/gis_params.dart';
import 'package:balady_plus/app/features/location/domain/entities/gis/gis_response.dart';
import 'package:balady_plus/app/features/location/domain/use_cases/get_gis_data.dart';
import 'package:balady_plus/app/features/weather/weather_exports.dart';
import 'package:bloc/bloc.dart';
import 'package:dgis_map/library.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/errors/errors_exports.dart';
import '../../../../core/services/local/navigation_services.dart';
import 'package:flutter/foundation.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeatherInfo _getWeatherInfo;
  final GetGISData _getGISData;
  WeatherBloc({required GetWeatherInfo getWeatherInfo})
    : _getWeatherInfo = getWeatherInfo,
      _getGISData = GetGISData(repository: sl()),
      super(WeatherState(gisResponse: CommonProperties.userLocationGIS)) {
    on<GetWeatherForLocation>(_getAllWeatherInfo);
    on<RefreshWeatherForLocation>(_refreshWeatherForLocation);

    on<ChangeIndexEvent>((event, emit) => emit(state.copyWith(selectedTile: event.index)));
  }

  Future<void> _getAllWeatherInfo(GetWeatherForLocation e, Emitter emitter) async {
    //   if (state.allWeatherInfoStatus == BlocStatus.success &&
    //     state.showLocationError == false) return;

    CommonFunctions.checkLocationSettings(NavigationService.navigatorKey.currentContext!);
    debugPrint("_getAllWeatherInfo");

    emitter(state.copyWith(allWeatherInfoStatus: BlocStatus.loading));

    GISParams? location = CommonProperties.userLocation;

    if (location == null) {
      LatLng? latlng = await Helpers.getCurrentLocation(accuracy: LocationAccuracy.low);

      location = GISParams(x: latlng?.longitude ?? 46.72364215018372, y: latlng?.latitude ?? 24.744615305066496);

      if (latlng == null) {
        emitter(state.copyWith(showLocationError: true));
      } else {
        emitter(state.copyWith(showLocationError: false));
      }
    } else {
      emitter(state.copyWith(showLocationError: false));
    }

    WeatherParams params = e.params.copyWith(latitude: location.y, longitude: location.x);

    final failureOrSuccess = await _getGISData(GISParams(x: params.longitude!, y: params.latitude!));
    await failureOrSuccess.fold(
      (failure) async {
        emitter(
          state.copyWith(
            allWeatherInfoStatus: BlocStatus.failure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ),
        );
      },
      (gisSuccess) async {
        final failureOrSuccess = await _getWeatherInfo(params);
        failureOrSuccess.fold(
          (failure) {
            debugPrint("failure: weather $failure");
            emitter(
              state.copyWith(
                allWeatherInfoStatus: BlocStatus.failure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
          (success) {
            debugPrint("weather entity: $success");
            emitter(
              state.copyWith(
                allWeatherInfoStatus: BlocStatus.success,
                gisResponse: gisSuccess,
                allWeatherInfo: success,
                errorMessage: "",
              ),
            );
          },
        );
      },
    );

    /*  ;*/
  }

  Future<void> _refreshWeatherForLocation(RefreshWeatherForLocation e, Emitter emitter) async {
    GISParams? location = CommonProperties.userLocation;

    if (location == null) {
      LatLng? latlng = await Helpers.getCurrentLocation(accuracy: LocationAccuracy.low);

      location = GISParams(x: latlng?.longitude ?? 46.72364215018372, y: latlng?.latitude ?? 24.744615305066496);

      if (latlng == null) {
        emitter(state.copyWith(showLocationError: true));
      } else {
        emitter(state.copyWith(showLocationError: false));
      }
    } else {
      emitter(state.copyWith(showLocationError: false));
    }

    WeatherParams params = e.params.copyWith(latitude: location.y, longitude: location.x);

    final failureOrSuccess = await _getWeatherInfo(params);
    failureOrSuccess.fold(
      (failure) {
        debugPrint("failure: weather $failure");
        emitter(state.copyWith());
      },
      (success) {
        debugPrint("weather entity: $success");
        emitter(state.copyWith(allWeatherInfoStatus: BlocStatus.success, allWeatherInfo: success, errorMessage: ""));
      },
    );

    /*  ;*/
  }
}
