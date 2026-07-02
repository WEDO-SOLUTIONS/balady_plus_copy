import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_box_click.g.dart';

@Riverpod(keepAlive: true)
class SearchBoxClick extends _$SearchBoxClick {
  @override
  DateTime? build() => null;

  // ignore: use_setters_to_change_properties
  void update(DateTime value) => state = value;
}
