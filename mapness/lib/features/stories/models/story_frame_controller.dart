import 'package:flutter/foundation.dart';

/// Controller for managing the actions of a story frame.
class StoryFrameController {
  /// Callback function for navigating to the next page.
  VoidCallback? nextPage;

  /// Callback function for navigating to the previous page.
  VoidCallback? prevPage;

  /// Callback function for pausing the playback.
  VoidCallback? pause;

  /// Callback function for playing the playback.
  VoidCallback? play;

  /// Disposes the controller by clearing all the callbacks.
  void dispose() {
    nextPage = null;
    prevPage = null;
    pause = null;
    play = null;
  }
}
