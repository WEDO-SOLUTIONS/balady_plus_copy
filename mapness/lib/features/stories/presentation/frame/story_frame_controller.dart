import 'package:flutter/foundation.dart';

class StoryFrameController {
  VoidCallback? nextPage;
  VoidCallback? prevPage;
  VoidCallback? pause;
  VoidCallback? play;

  void dispose() {
    nextPage = null;
    prevPage = null;
    pause = null;
    play = null;
  }
}
