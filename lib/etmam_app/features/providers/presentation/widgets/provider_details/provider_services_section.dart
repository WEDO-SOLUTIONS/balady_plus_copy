import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/etmam_app/core/utils/common_properties.dart';
import 'package:balady_plus/etmam_app/features/home/home_exports.dart';
import 'package:balady_plus/etmam_app/features/providers/presentation/blocs/provider_details_bloc/provider_details_bloc.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show ServiceDetailsParams;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/constants/app_config.dart';
import '../../../../_shared_feature_/shared/shared_feature_exports.dart'
    show CustomVerticalSpace, SectionTitleWidget;

class ProviderServicesSection extends StatelessWidget {
  const ProviderServicesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderDetailsBloc, ProviderDetailsState>(
      builder: (context, state) {
        return state.args.supportedServices != null
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CustomTextWidget(
                  trans("provider_services"),
                  fontColor: AppColor.blackModern800Light,
                  fontSize: 16,
                  fontWeight: AppFontWeight.bold,
                ),
                const CustomVerticalSpace(height: 16),
                GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20.0,
                            mainAxisExtent: 162),
                    itemCount: state.args.supportedServices?.length ?? 0,
                    itemBuilder: (ctx, index) {
                      return EtmamSubServiceCardWidget(
                        subServiceIcon:
                            state.args.supportedServices?[index].logoImageUrl ??
                                "",
                        subServiceName:
                            state.args.supportedServices?[index].serviceName ??
                                "",
                        btnPressed: () {
                          context.read<ProviderDetailsBloc>().add(
                              GetServiceDetailsEvent(
                                  params: ServiceDetailsParams(
                                      serviceProviderId: state.args.id ?? "",
                                      cityId: CommonProperties.cityId,
                                      subServiceId: state
                                              .args
                                              .supportedServices?[index]
                                              .serviceId ??
                                          "")));
                        },
                      );
                    }),
                const CustomVerticalSpace(height: 12),
              ])
            : Container();
      },
    );
  }
}
