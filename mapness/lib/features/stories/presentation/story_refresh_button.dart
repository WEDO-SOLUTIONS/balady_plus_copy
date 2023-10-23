import 'package:flutter/material.dart';

class StoryRefreshButton extends StatelessWidget {
  final VoidCallback onPressed;

  const StoryRefreshButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
