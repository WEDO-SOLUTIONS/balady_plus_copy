import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/pages/violation_address_select_page.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_create_widgets/violation_create_option_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_create_widgets/violation_create_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../bloc/violation_bloc.dart';
import '../../bloc/violation_state.dart';

class ViolationCreateListWidget extends StatelessWidget {
  const ViolationCreateListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationBloc, ViolationState>(
        builder: (context, state) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(
            height: 24,
          ),
          const ViolationCreateTitleWidget(),
          const SizedBox(
            height: 24,
          ),
          Container(
            height: 400,
            child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: state.violatorResponse?.result?.length,
                itemBuilder: (context, index) {
                  return ViolationCreateOptionWidget(
                    onPressed: () {
                      context.read<ViolationBloc>().selectViolatorType(
                          state.violatorResponse!.result![index]);
                    },
                    optionTitle:
                        state.violatorResponse?.result?[index].violatorType ??
                            "",
                  );
                }),
          ),
          const SizedBox(
            height: 24,
          ),
        ]),
      );
    });
  }
}
