import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/splash/data/splash_remote_data_source.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final SplashRemoteDataSource splashRemoteDataSource;

  SplashCubit({required this.splashRemoteDataSource}) : super(const InitialSplashState()) {
    fetchSplashData();
  }

  void fetchSplashData() async {
    try {
      final splashData = await splashRemoteDataSource.getSplash();
      final currentDate = DateTime.now();
      final startDate = splashData.startDate;
      final endDate = splashData.endDate;
      if (currentDate.isAfter(startDate) &&
          currentDate.isBefore(endDate) &&
          splashData.splashImage != '') {
        emit(
          OnlineSplashState(
            splashUrl: splashData.splashImage,
            splashDuration: splashData.seasonalSplashDuration,
          ),
        );
      } else {
        emit(const OfflineSplashState());
      }
    } catch (e) {
      emit(const OfflineSplashState());
    }
  }


  void emitCompletedSplashState() {
    emit(const CompletedSplashState());
  }

}
