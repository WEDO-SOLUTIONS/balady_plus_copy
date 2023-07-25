import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/weather/domain/usecases/get_weather_info.dart';
import 'package:balady_plus/app/features/weather/weather_exports.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/errors/errors_exports.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeatherInfo _getWeatherInfo;
  WeatherBloc({
    required GetWeatherInfo getWeatherInfo,
  })  : _getWeatherInfo = getWeatherInfo,
        super(WeatherState()) {
    on<GetWeatherForLocation>(_getAllWeatherInfo);

    add(GetWeatherForLocation());
  }

  Future<void> _getAllWeatherInfo(
      GetWeatherForLocation e, Emitter emitter) async {
    emitter(state.copyWith(allWeatherInfoStatus: BlocStatus.loading));

    LatLng? location = await Helpers.getCurrentLocation();

    e.params
        .copyWith(latitude: location?.latitude, longitude: location?.longitude);
    final failureOrSuccess = await _getWeatherInfo(e.params);

    failureOrSuccess.fold((failure) {
      print("failure: $failure");
      emitter(state.copyWith(
        allWeatherInfoStatus: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      print("weather entity: $success");
      emitter(state.copyWith(
        allWeatherInfoStatus: BlocStatus.success,
        //  categories: success.data?.result,

        allWeatherInfo: success,
        errorMessage: "",
      ));
    });
  }
}
