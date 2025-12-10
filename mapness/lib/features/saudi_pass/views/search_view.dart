import 'package:flutter/widgets.dart';

abstract class SearchView {
  String get title;

  bool get isMagnifierVisible;

  void onTap(BuildContext context);
}
