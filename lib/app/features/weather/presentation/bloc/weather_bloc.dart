import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
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
        super(WeatherState()) {
    on<GetWeatherForLocation>(_getAllWeatherInfo);

    add(GetWeatherForLocation());
  }

  Future<void> _getAllWeatherInfo(
      GetWeatherForLocation e, Emitter emitter) async {
    if (state.allWeatherInfoStatus == BlocStatus.success) return;

    emitter(state.copyWith(allWeatherInfoStatus: BlocStatus.loading));

    GISParams? location = CommonProperties.userLocation;

    if (location == null) {
      LatLng? latlng = await Helpers.getMapLocation();
      location = GISParams(
          x: latlng?.longitude ?? 46.72364215018372,
          y: latlng?.latitude ?? 24.744615305066496);
    }

    // WeatherParams params =
    //     e.params.copyWith(latitude: location.y, longitude: location.x);

    final failureOrSuccess = await _getWeatherInfo(e.params);

    failureOrSuccess.fold((failure) {
      print("failure: weather $failure");
      emitter(state.copyWith(
        allWeatherInfoStatus: BlocStatus.failure,
        gisResponse: CommonProperties.userLocationGIS,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      print("weather entity: $success");
      emitter(state.copyWith(
        allWeatherInfoStatus: BlocStatus.success,
        //  categories: success.data?.result,
        gisResponse: CommonProperties.userLocationGIS,
        allWeatherInfo: success,
        errorMessage: "",
      ));
    });

/*  final failureOrSuccess = await _getGISData(
        GISParams(x: e.params.longitude!, y: e.params.latitude!));

    await failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        allWeatherInfoStatus: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      emitter(state.copyWith(
        gisResponse: success,
        errorMessage: "",
      ));

    
    });*/
  }
}
