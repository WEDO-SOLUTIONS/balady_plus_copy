import 'package:flutter/material.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/custom_button.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../shared_features/new_app_bar.dart';
import '../../data/models/rating_items_response.dart';
import '../../domain/entities/submit_rating_request.dart';

class ResultLoading extends StatelessWidget {
  final double value;
  final List<InspectionSubClausesList> nonCompliance;
  const ResultLoading(
      {super.key, required this.value, required this.nonCompliance});

  @override
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
