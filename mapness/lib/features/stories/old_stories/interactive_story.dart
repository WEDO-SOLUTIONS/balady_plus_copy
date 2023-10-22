// import 'package:flutter/material.dart';
// import 'package:mapness/core/common/image/loading_image/loading_shimmer_image.dart';

// class InteractiveStory extends StatefulWidget {
//   final void Function(InteractiveStoryPageAction) onActionPressed;
//   final InteractiveStoryData story;
//   final void Function(int) onPageChanged;
//   final VoidCallback onClose;

//   const InteractiveStory({
//     super.key,
//     required this.story,
//     required this.onActionPressed,
//     required this.onPageChanged,
//     required this.onClose,
//   });

//   @override
//   State<InteractiveStory> createState() => _InteractiveStoryState();
// }

// class _InteractiveStoryState extends State<InteractiveStory> with SingleTickerProviderStateMixin {
//   bool isLoading = true;
//   static const Duration duration = Duration(seconds: 5);

//   final tween = Tween<double>(begin: 0, end: 1);
//   late final AnimationController _animationController;

//   late DateTime lastTapDown;

//   late ProgressStoryData progressData;

//   @override
//   void initState() {
//     super.initState();
//     lastTapDown = DateTime.now();
//     _animationController = AnimationController(vsync: this, duration: duration);
//     final notWatchedIndex = widget.story.pages.indexWhere((e) => !e.isWatched);

//     progressData = ProgressStoryData(
//       length: widget.story.pages.length,
//       currentIndex: notWatchedIndex == -1 ? 0 : notWatchedIndex,
//       progress: 0,
//     );
//     _animationController.addListener(() {
//       progressData = progressData.copyWith(progress: _animationController.value);
//     });
//     _animationController.addStatusListener(statusListener);
//     // _animationController.forward();
//   }

//   @override
//   void didUpdateWidget(covariant InteractiveStory oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.story != widget.story) {
//       _animationController.reset();
//       _animationController.forward();
//     }
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   void statusListener(AnimationStatus status) {
//     if (status == AnimationStatus.completed) {
//       nextStory();
//     }
//   }

//   void pageChanged() {
//     /// reset progress
//     // _animationController.forward(from: 0);
//     isLoading = true;
//     widget.onPageChanged(progressData.currentIndex);
//   }

//   void startTimer() {
//     isLoading = false;
//     _animationController.forward(from: 0);
//   }

//   void nextStory() {
//     /// close story when end
//     if (progressData.currentIndex + 1 >= progressData.length) {
//       Navigator.of(context).pop();
//       return;
//     }

//     /// next page
//     setState(() {
//       progressData = progressData.copyWith(
//         currentItem: progressData.currentIndex + 1,
//         progress: 0,
//       );
//     });
//     pageChanged();
//   }

//   void previousStory() {
//     /// previous page
//     setState(() {
//       progressData = progressData.copyWith(
//         currentItem: progressData.currentIndex - 1 < 0 ? 0 : progressData.currentIndex - 1,
//         progress: 0,
//       );
//     });
//     pageChanged();
//   }

//   void onTapDown(TapDownDetails details) {
//     lastTapDown = DateTime.now();
//     _animationController.stop();
//   }

//   void tapPauseOrAction(VoidCallback action) {
//     if ((DateTime.now().difference(lastTapDown).inMilliseconds) < 150) {
//       action();
//       return;
//     }
//     _animationController.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final page = widget.story.pages[progressData.currentIndex];

//     return ;
//   }
// }
