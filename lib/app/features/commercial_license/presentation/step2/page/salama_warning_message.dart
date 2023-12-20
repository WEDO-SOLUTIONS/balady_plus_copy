import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SalamaWarningMessage extends StatefulWidget {
  final String message;

  const SalamaWarningMessage({super.key, required this.message});

  @override
  State<SalamaWarningMessage> createState() => _SalamaWarningMessageState();
}

class _SalamaWarningMessageState extends State<SalamaWarningMessage> {
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
