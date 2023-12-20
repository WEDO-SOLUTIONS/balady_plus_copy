import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';

class WarningMessage extends StatefulWidget {
  final String message;

  const WarningMessage({super.key, required this.message});

  @override
  State<WarningMessage> createState() => _SalamaWarningMessageState();
}

class _SalamaWarningMessageState extends State<WarningMessage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CustomVerticalSpace(height: 32),
        NotesWidget(notes: [widget.message])
      ],
    );
  }
}
