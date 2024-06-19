import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_query.g.dart';

@Riverpod(keepAlive: true)
class MediaQueryInfo extends _$MediaQueryInfo {
  @override
  MediaQueryData? build() => null;

  // ignore: use_setters_to_change_properties
  void update(MediaQueryData data) {
    state = data;
  }
}
