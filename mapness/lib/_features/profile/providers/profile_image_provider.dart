import 'dart:convert';
import 'dart:typed_data';

import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/_features/profile/domain/user_profile_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_image_provider.g.dart';

@riverpod
class ProfileImage extends _$ProfileImage {
  static const _imagePrefsKey = 'user_profile_image_base64';

  SharedPreferences get _prefs => ref.read(sharedPrefsProvider);

  Future<void> changeUserProfileImageByBytes(Uint8List bytes) async {
    final imageBase64 = base64Encode(bytes);
    await _prefs.setString(_imagePrefsKey, imageBase64);
    ref.invalidateSelf();
  }

  @override
  Future<UserProfileData> build() async {
    final imageBase64 = _prefs.getString(_imagePrefsKey);

    return UserProfileData(
      imageBase64: imageBase64 ?? '',
    );
  }
}
