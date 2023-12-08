import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/under_testing/custom_enhanced_expansion_panel_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_style.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../home_page/home_exports.dart';
import '../../../domain/entities/sub_activity_details_entity.dart';

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
