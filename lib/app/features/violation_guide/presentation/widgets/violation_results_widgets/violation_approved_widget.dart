import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/custom_expansion_panel.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/under_testing/custom_enhanced_expansion_panel_list_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/pages/approved_violation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../bloc/violation_bloc.dart';
import '../../bloc/violation_event.dart';
import '../../bloc/violation_state.dart';
import 'violation_details_widget.dart';

class ViolationApprovedWidget extends StatelessWidget {
  const ViolationApprovedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationBloc, ViolationState>(
        builder: (context, state) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: ListView.builder(
          itemCount: state.critical().length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                context.read<ViolationBloc>().add(
                    GetRegulationClausesDetails(item: state.critical()[index]));
              },
              child: ViolationDetailsWidget(
                item: state.critical()[index],
              ),
            );
          },
        ),
      );
    });
  }
}
