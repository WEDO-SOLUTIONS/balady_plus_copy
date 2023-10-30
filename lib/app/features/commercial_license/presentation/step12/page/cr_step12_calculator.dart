import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';
import '../bloc/cr_step12_sadad_cubit.dart';

class CRStep12CalculatorReview extends StatelessWidget {
  const CRStep12CalculatorReview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CrStep12SadadCubit, CrStep12SadadState>(
        listener: (context, state) {
      if (state.status == BlocStatus.failure) {
        CommonFunctions.showError(state.errorMessage);
      }
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
                        const CRHeaderDesc(header: "عدد السنوات"),
                        DropDownWithTitle(
                          title: "عدد السنوات".tr(),
                          selectedValue: state.selectedPeriod,
                          onRetry: null,
                          onTap: () {
                            BottomSheetDialog.showDraggableSheet<String>(
                              context,
                              // dialogKeyName: DialogName.objectablePageProductsFilters,
                              // currentRouteName: RouteName.objectableTransactions,
                              child: BottomSheetList(
                                title: "عدد السنوات".tr(),
                                items: state.period ?? [],
                                selectedValue: state.selectedPeriod,
                                onTap: (item) {
                                  context
                                      .read<CrStep12SadadCubit>()
                                      .onSelectSaddadYear(item);

                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              CRPreviousNextButtons(
                  onPressed: () {
                    context.read<CrStep12SadadCubit>().calculate();
                  },
                  isBtnDisabled: false),
            ],
          ),
          if (state.status.isSubmissionLoading)
            const CustomCircularLoadingWidget(),
        ],
      );
    });
  }
}
