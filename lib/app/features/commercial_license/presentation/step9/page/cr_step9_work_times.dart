import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../commercial_license_exports.dart';

class CRStep9WorkTimes extends StatelessWidget {
  const CRStep9WorkTimes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CRHeaderDesc(header: "مواعيد العمل"),
                  const SizedBox(height: 16),
                  BlocBuilder<WorkTimesCubit, WorkTimesState>(
                    buildWhen: (previous, current) =>
                        previous.workTimes != current.workTimes,
                    builder: (context, state) {
                      return ListView.separated(
                        itemCount: state.workTimes.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, index) => WorkTimeCard(index: index),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        const CRPreviousNextButtons(isBtnDisabled: false),
      ],
    );
  }
}
