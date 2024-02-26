import 'package:flutter/material.dart';

class StoryRefreshButton extends StatelessWidget {

  const StoryRefreshButton({required this.onPressed, super.key});
  final VoidCallback onPressed;

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
