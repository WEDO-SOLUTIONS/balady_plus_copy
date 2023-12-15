import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/_features/profile/domain/user_profile_data.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;

part 'profile_image_provider.g.dart';

@riverpod
class ProfileImage extends _$ProfileImage {
  static const _imagePrefsKey = 'user_profile_image_base64';

  SharedPreferences get _prefs => ref.read(sharedPrefsProvider);

  String? get _imageBase64OnDevice => _prefs.getString(_imagePrefsKey);

  bool _isUpdated = false;

  @override
  Future<UserProfileData> build() async {
    if (!_isUpdated) {
      updateImageFromBackend().then((_) {
        _isUpdated = true;
      });
    }

    return UserProfileData(
      imageBase64: _imageBase64OnDevice ?? '',
    );
  }

  Future<void> updateImageFromBackend() async {
    final backendImage = await _downloadProfileImageToBytes();

    if (backendImage.isNotEmpty) {
      await _saveImageBytes(backendImage);
    }
    ref.invalidateSelf();
  }

  Future<void> changeUserProfileImageByBytes(Uint8List bytes) async {
    try {
      ref.invalidateSelf();

      await _uploadImage(bytes);
      await _saveImageBytes(bytes);

      ref.invalidateSelf();
    } catch (error, trace) {
      _log(error, trace);
    }
  }

  /// Сохраняет изображение локально в base64.
  /// Возвращает строку base64.
  Future<String> _saveImageBytes(Uint8List bytes) async {
    final imageBase64 = base64Encode(bytes);
    await _prefs.setString(_imagePrefsKey, imageBase64);
    return imageBase64;
  }

  /// Загружает изображение на бекенд.
  /// Возвращает ссылку на изображение.
  Future<String> _uploadImage(Uint8List bytes) async {
    final env = await ref.read(dgisEnvironmentProvider.future);
    final url = env.url;
    final dio = ref.read(dGisNetworkProvider(url));

    try {
      final response = await dio.post(
        "/profile/photo",
        data: bytes,
      );

      final result = proto.Profile_Photo.fromBuffer(response.data);

      return result.image.url;
    } catch (error, trace) {
      _log(error, trace);
      rethrow;
    }
  }

  Future<Uint8List> _downloadProfileImageToBytes({String url = ''}) async {
    final env = await ref.read(dgisEnvironmentProvider.future);
    final _url = env.url;
    final _dio = ref.read(dGisNetworkProvider(_url));
    try {
      if (url.isEmpty) {
        final profileResponse = await _dio.get('/profile');
        final profileData =
            proto.ProfileResponse.fromBuffer(profileResponse.data);
        url = profileData.profile.photo.image.url;
      }

      if (url.isEmpty) {
        return Uint8List(0);
      }

      final response = await _dio.get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      return response.data;
    } catch (error, trace) {
      _log(error, trace);
      rethrow;
    }
  }

  void _log(Object? data, [StackTrace? trace]) {
    debugPrint(data.toString());
    if (trace != null) {
      debugPrintStack(stackTrace: trace);
    }
  }
}
