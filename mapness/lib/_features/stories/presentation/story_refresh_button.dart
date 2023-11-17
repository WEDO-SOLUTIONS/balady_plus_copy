import 'package:flutter/material.dart';

class StoryRefreshButton extends StatelessWidget {
  final VoidCallback onPressed;

  const StoryRefreshButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.refresh),
          ),
        ),
      ),
    );
  }
}
