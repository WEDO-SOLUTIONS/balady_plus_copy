import 'dart:typed_data';

import 'package:balady_uikit/components.dart';

sealed class AvatarData {
  final bool isGrayScale;
  const AvatarData({this.isGrayScale = false});
}

class AvatarLoading extends AvatarData {
  final LoaderStyle style;
  const AvatarLoading({
    this.style = LoaderStyle.accent,
    super.isGrayScale = false,
  });
}

enum AvatarEmptyStyle {
  accent,
  accentSecondary,
  extra01,
}

class AvatarDataEmpty extends AvatarData {
  final String? value;
  final AvatarEmptyStyle style;

  const AvatarDataEmpty({
    this.value,
    this.style = AvatarEmptyStyle.accentSecondary,
    super.isGrayScale = false,
  });
}

class AvatarUrl extends AvatarData {
  final String url;
  final String? value;

  const AvatarUrl(
    this.url, {
    this.value,
    super.isGrayScale = false,
  });
}

class AvatarBytes extends AvatarData {
  final Uint8List bytes;
  final String? value;

  const AvatarBytes(
    this.bytes, {
    this.value,
    super.isGrayScale = false,
  });
}
