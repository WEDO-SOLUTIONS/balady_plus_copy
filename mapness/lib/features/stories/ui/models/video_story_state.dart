part of '../story_video_player.dart';

enum VidoErrorType {
  network,
  file,
  asset,
}

sealed class VideoStoryState {}

class VideoStoryLoading extends VideoStoryState {}

class VideoStoryReady extends VideoStoryState {}

class VideoStoryError extends VideoStoryState {
  final VidoErrorType errorType;
  final String message;

  VideoStoryError(this.message, this.errorType);
}
