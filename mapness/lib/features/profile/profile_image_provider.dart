import 'dart:convert';
import 'dart:typed_data';

import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;
import 'package:mapness/entities/profile/user_profile_data.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/base_dio.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_image_provider.g.dart';

@riverpod
class ProfileImage extends _$ProfileImage {
  static const _imagePrefsKey = 'user_profile_image_base64';

  SharedPreferences get _prefs => ref.read(sharedPrefsProvider);

  String? get _imageBase64OnDevice => _prefs.getString(_imagePrefsKey);

  bool _isUpdated = false;
  int _requestGeneration = 0;

  PermissionStatus status = PermissionStatus.denied;

  @override
  Future<UserProfileData> build() async {
    Permission.photos.status.then((val) {
      status = val;
    });
    if (CommonProperties.isLoggedIn && !_isUpdated) {
      _updateImageFromBackend().ignore();
    }

    return UserProfileData(imageBase64: _imageBase64OnDevice ?? '');
  }

  Future<void> _updateImageFromBackend() async {
    final generation = _requestGeneration;
    final backendImage = await _downloadProfileImageToBytes();
    if (!ref.mounted || generation != _requestGeneration) {
      return;
    }

    await _updateImageState(backendImage);
    _isUpdated = true;
  }

  Future<void> changeUserProfileImageByBytes(Uint8List bytes) async {
    try {
      await _updateImageState(bytes);

      await _uploadImage(bytes);

      await _updateImageFromBackend();
    } catch (error, trace) {
      _log(error, trace);
    }
  }

  Future<void> _updateImageState(Uint8List bytes) async {
    if (bytes.isNotEmpty) {
      final imgBase64 = await _saveImageBytes(bytes);
      if (imgBase64 != null) {
        state = AsyncData(UserProfileData(imageBase64: imgBase64));
      }
    }
  }

  /// Сохраняет изображение локально в base64.
  /// Возвращает строку base64.
  Future<String?> _saveImageBytes(Uint8List bytes) async {
    final imageBase64 = base64Encode(bytes);
    if (_imageBase64OnDevice?.contains(imageBase64) == true) {
      return null;
    }
    await _prefs.setString(_imagePrefsKey, imageBase64);
    return imageBase64;
  }

  Future<Uint8List> _comporessList(Uint8List list) async {
    final result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 200,
      minWidth: 200,
      quality: 40,
    );
    return result;
  }

  /// Загружает изображение на бекенд.
  /// Возвращает ссылку на изображение.
  Future<String> _uploadImage(Uint8List bytes) async {
    final compressedBytes = await _comporessList(bytes);
    // start the timer for the event "Image Upload"
    Metrics.logEvent('Profile_Image_Upload');
    mixpanel?.timeEvent('Profile Image Upload');

    final dio = await ref.read(dGisNetworkProvider.future);
    try {
      final response = await dio.post(
        '/profile/photo',
        data: compressedBytes,
        options: Options(
          sendTimeout: const Duration(seconds: 35),
          receiveTimeout: const Duration(seconds: 35),
        ),
      );

      final result = proto.Profile_Photo.fromBuffer(response.data as List<int>);
      await mixpanel?.track('Profile Image Upload');
      return result.image.url;
    } catch (error, trace) {
      _log(error, trace);
      rethrow;
    }
  }

  Future<Uint8List> _downloadProfileImageToBytes({String url = ''}) async {
    final dio = await ref.read(dGisNetworkProvider.future);
    final imageRequestDio = ref.watch(baseDioProvider);
    String imgUrl = url;
    try {
      if (imgUrl.isEmpty) {
        final profileResponse = await dio.get('/profile');
        final profileData = proto.ProfileResponse.fromBuffer(
          profileResponse.data as List<int>,
        );
        imgUrl = profileData.profile.photo.image.url;
      }

      if (imgUrl.isEmpty) {
        return Uint8List(0);
      }

      // start image with base dio
      final response = await imageRequestDio.get(
        imgUrl,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 35),
          followRedirects: false,
        ),
      );
      return response.data as Uint8List;
    } catch (error, trace) {
      _log(error, trace);
      rethrow;
    }
  }

  void _log(Object? data, [StackTrace? trace]) {
    logger.log(data.toString(), logLevel: MapnessLogLevel.critical);
    if (trace != null) {
      debugPrintStack(stackTrace: trace);
    }
  }

  Future<void> clear() async {
    _requestGeneration++;
    await _prefs.remove(_imagePrefsKey);
    state = const AsyncData(UserProfileData());
    _isUpdated = false;
  }
}
