import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/splash/data/splash_remote_data_source.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final SplashRemoteDataSource splashRemoteDataSource;

  SplashCubit({required this.splashRemoteDataSource}) : super(SplashState()) {
    fetchSplashData();
  }

  Future<void> fetchSplashData() async {
    try {
      final splashData = await splashRemoteDataSource.getSplash();
      final currentDate = DateTime.now();
      final startDate = splashData.startDate;
      final endDate = splashData.endDate;

      if (currentDate.isAfter(startDate) &&
          currentDate.isBefore(endDate) &&
          splashData.splashImage != '') {
        emit(state.copyWith(
            status: BlocStatus.success,
            splashUrl: splashData.splashImage,
            splashDuration: splashData.seasonalSplashDuration));
      } else {
        emit(state.copyWith(status: BlocStatus.failure));
      }
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.failure));
    }
  }
}
