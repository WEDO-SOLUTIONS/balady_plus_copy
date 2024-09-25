import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../commercial_license_exports.dart';

class CRStep9WorkTimes extends StatefulWidget {
  const CRStep9WorkTimes({Key? key}) : super(key: key);

  @override
  State<CRStep9WorkTimes> createState() => _CRStep9WorkTimesState();
}

class _CRStep9WorkTimesState extends State<CRStep9WorkTimes> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<WorkTimesCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkTimesCubit, WorkTimesState>(
        listener: (context, state) {
      if (state.status == BlocStatus.failure)
        CommonFunctions.showError(state.errorMessage ?? "");
    }, builder: (context, state) {
      return Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CRHeaderDesc(header: "step11title7".tr()),
                        const SizedBox(height: 16),
                        BlocBuilder<WorkTimesCubit, WorkTimesState>(
                          buildWhen: (previous, current) =>
                              previous.workingTimes != current.workingTimes,
                          builder: (context, state) {
                            return ListView.separated(
                              itemCount: state.workingTimes?.length ?? 0,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (_, index) =>
                                  WorkTimeCard(index: index),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              (state.status.isSubmissionLoading)
                  ? const Center(child: CustomCircularLoadingWidget())
                  : CRPreviousNextButtons(
                onPressed: () {
                  context.read<WorkTimesCubit>().save();

                  //   sl<CommercialLicenseBloc>().add(const GoToNextPageEvent());
                },
                isBtnDisabled: false,
              ),
            ],
          ),
          if (state.status == BlocStatus.loading)
            const CustomCircularLoadingWidget(),
        ],
      );
    });
  }
}
