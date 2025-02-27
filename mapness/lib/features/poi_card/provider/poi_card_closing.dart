import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'poi_card_closing.g.dart';

@riverpod
class PoiCardClosing extends _$PoiCardClosing {
  @override
  bool build() => false;

  void close() => state = true;
}
