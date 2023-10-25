import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/stories/data/story_service.dart';
import 'package:mapness/features/stories/presentation/frame/dismissible_overlay.dart';
import 'package:mapness/features/stories/presentation/stories_fullscreen.dart';
import 'package:mapness/features/stories/presentation/story_refresh_button.dart';
import 'package:mapness/features/stories/presentation/story_thumbnails.dart';

class StoriesWidget extends ConsumerStatefulWidget {
  const StoriesWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<StoriesWidget> createState() => _StoriesWidgetState();
}

final GlobalKey<DismissibleTransitionState> _transitionState = GlobalKey();

class _StoriesWidgetState extends ConsumerState<StoriesWidget> {
  OverlayEntry? _overlayEntry;

  openStory(BuildContext context, String id) {
    final storyWidget = StoriesFullscreen(
      onClose: () => _transitionState.currentState?.dismiss(),
      initialStoryId: id,
    );

    _overlayEntry = OverlayEntry(
      builder: (context) => ProviderScope(
        parent: ProviderScope.containerOf(context),
        child: DismissibleTransition(
          key: _transitionState,
          onDismiss: () {
            _overlayEntry?.remove();
            _overlayEntry = null;
          },
          child: storyWidget,
        ),
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    final thumbnails = ref.watch(storyServiceProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: thumbnails.when(
        data: (data) => StoryThumbnails(
          onThumbnailPressed: (id) => openStory(context, id),
          thumbnails: data.thumbnails,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => StoryRefreshButton(
          onPressed: () => ref.read(storyServiceProvider.notifier).refresh(),
        ),
      ),
    );
  }
}
