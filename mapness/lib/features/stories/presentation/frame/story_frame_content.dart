import 'package:flutter/material.dart';
import 'package:mapness/features/stories/domain/frame/story_frame_data.dart';

class StoryFrameContent extends StatelessWidget {
  final StoryFrameData frame;

  const StoryFrameContent({
    super.key,
    required this.frame,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  frame.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontFamily: 'TheSansArab',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.56,
                  ),
                ),
                if (frame.subtitle != null)
                  Text(
                    frame.subtitle!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontFamily: 'TheSansArab',
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.56,
                    ),
                  ),
                const SizedBox(height: 21),
                if (frame.description != null)
                  Text(
                    frame.description!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'TheSansArab',
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.32,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
