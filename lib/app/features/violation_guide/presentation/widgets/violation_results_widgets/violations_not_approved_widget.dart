import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_bloc.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_state.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_results_widgets/violation_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../bloc/violation_event.dart';

class ViolationsNotApprovedWidget extends StatelessWidget {
  const ViolationsNotApprovedWidget({super.key});

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
          itemCount: state.notCritical().length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                context.read<ViolationBloc>().add(GetRegulationClausesDetails(
                    item: state.notCritical()[index]));
              },
              child: ViolationDetailsWidget(
                item: state.notCritical()[index],
              ),
            );
          },
        ),
      );
    });
  }
}
