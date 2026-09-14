import 'dart:convert';
import 'dart:io';

import 'package:balady_plus/app/core/services/local/shared_prefs_manager.dart';
import 'package:balady_plus/app/features/splash/data/splash_remote_data_source.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final SplashRemoteDataSource splashRemoteDataSource;

  SplashCubit({required this.splashRemoteDataSource}) : super(const InitialSplashState()) {
    fetchSplashData();
  }

  void fetchSplashData() async {
    try {
      debugPrint('SPLASH DEBUG: fetchSplashData called');
      // Offline splash data is disabled: sharedPrefs.getDataOfSplash();
      debugPrint('SPLASH DEBUG: No offline splash data, emitting OfflineSplashState');
      emit(const OfflineSplashState());
      // getNewOnlineSplashAndDownload();
    } catch (e) {
      emit(const OfflineSplashState());
    }
  }

  void emitCompletedSplashState() {
    emit(const CompletedSplashState());
  }

  void getNewOnlineSplashAndDownload() async {
    final splashData = await splashRemoteDataSource.getSplash();
    sharedPrefs.saveDataOfSplash(jsonEncode(splashData.toJson()));
    // final currentDate = DateTime.now();
    // final startDate = splashData.startDate;
    // final endDate = splashData.endDate;
    // if (currentDate.isAfter(startDate) && currentDate.isBefore(endDate) && splashData.splashImage != '') {
    /// Download The New specific Splash Image
    await downloadNewSplashImage(splashData.splashImage);
    // } else if (splashData.defaultImage.isNotEmpty) {
    /// Download The normal Splash Image
    await downloadNewSplashImage(splashData.defaultImage);
    // }
  }

  Future<void> downloadNewSplashImage(String splashImageURL) async {
    await splashRemoteDataSource.downloadNewSplashImage(splashImageURL);
  }

  void checkSaveFile(String splashImage, int defaultSplashDuration) async {
    final directory = await getTemporaryDirectory();
    String pathImage = directory.path + splashImage.split('/').last;
    File file = File(pathImage);
    if (file.existsSync()) {
      emit(OnlineSplashState(splashFile: file, splashDuration: defaultSplashDuration));
    } else {
      emit(const OfflineSplashState());
      downloadNewSplashImage(splashImage);
    }
  }
}
