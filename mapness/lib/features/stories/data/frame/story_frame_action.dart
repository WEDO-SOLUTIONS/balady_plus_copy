sealed class StoryFrameAction {
  final String title;
  final FrameActionType type;
  final String action;

  const StoryFrameAction({
    required this.type,
    required this.action,
    required this.title,
  });
}

enum FrameActionType {
  callPhone,
  openUrl,
  openDeepLink,
  openMap,
}
