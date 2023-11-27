import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, IconPath;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show
        CustomAutoSizeTextWidget,
        CustomTextWidget,
        DrawIconBasedTypeWidget,
        DrawLineWidget,
        ElevatedButtonWidget;
import '../cubit/service_cards_cubit/service_cards_cubit.dart'
    show ServiceCardsCubit, ServiceCardsState;

class ServiceWarningWidget extends StatelessWidget {
  final String warning;
  final Function? onPress;

  const ServiceWarningWidget({super.key, required this.warning, this.onPress});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceCardsCubit, ServiceCardsState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          height: state.expandedWarning ? 320 : 160,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(36),
              topRight: Radius.circular(36),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.dark5,
                offset: Offset(0, -4),
                blurRadius: 32,
              )
            ],
            color: AppColor.white,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(36),
              topRight: Radius.circular(36),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () =>
                          context.read<ServiceCardsCubit>().toggleWarning(),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: DrawLineWidget(
                          lineWidth: 70.0,
                          lineHeight: 6.0,
                          lineColor: AppColor.gray,
                          radius: 46.0,
                        ),
                      ),
                    ),
                    if (state.expandedWarning) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const DrawIconBasedTypeWidget(
                            icon: IconPath.warnings,
                            iconSize: 22,
                          ),
                          const SizedBox(width: 8),
                          CustomTextWidget(
                            'warnings'.tr(),
                            textStyle:
                                AppStyle.serviceCardWarningTitleTextStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          child: CustomAutoSizeTextWidget(
                            warning,
                            textStyle: AppStyle.serviceCardDescriptionTextStyle,
                            maxLines: 20,
                          ),
                        ),
                      ),
                    ],
                    if (!state.expandedWarning) const Spacer(),
                    ElevatedButtonWidget.startService(
                      onPressed: () => onPress != null ? onPress!() : () {},
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
