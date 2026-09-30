import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the landing page is on screen: its bottom-menu tab is selected and no route covers it.
///
/// The map camera keeps moving under the POI card, search and the other tabs, so landing-only content that follows
/// the camera (stories, interesting places) pauses its requests while this is `false` and catches up once the
/// landing is visible again.
final landingVisibleProvider = NotifierProvider<LandingVisibility, bool>(LandingVisibility.new);

class LandingVisibility extends Notifier<bool> {
  bool _tabActive = true;
  bool _routeCovered = false;

  @override
  bool build() => _tabActive && !_routeCovered;

  void setTabActive({required bool active}) {
    _tabActive = active;
    _sync();
  }

  void setRouteCovered({required bool covered}) {
    _routeCovered = covered;
    _sync();
  }

  void _sync() {
    final visible = _tabActive && !_routeCovered;
    if (state != visible) {
      state = visible;
    }
  }
}
