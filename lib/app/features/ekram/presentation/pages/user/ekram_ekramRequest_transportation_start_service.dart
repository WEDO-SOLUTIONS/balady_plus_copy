import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_style.dart';
import '../../../../../core/utils/constants/route_names.dart';
import '../../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import '../../blocs/ekram_requests_bloc/ekram_requests_bloc.dart';

class EkramRequestTransportationStartService extends StatelessWidget {
  const EkramRequestTransportationStartService({super.key});

  @override
  Widget build(BuildContext context) {
    EkramRequestsBloc? ekramRequestsBloc =
        ModalRoute.of(context)!.settings.arguments as EkramRequestsBloc?;

    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: "ekram_benf_transport".tr(),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.darkSlateBlue6,
                            offset: Offset(0, -4),
                            blurRadius: 32,
                          )
                        ],
                        color: AppColor.blackModern50Light,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              DrawIconBasedTypeWidget(
                                icon: IconPath.msgBoxIcon,
                              ),
                              const SizedBox(width: 4),
                              CustomTextWidget(
                                "ekram_condolence_msg_title".tr(),
                                textStyle: AppStyle.cardTitleTextStle,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextWidget(
                                "ekram_condolence_msg".tr(),
                                textStyle:
                                    AppStyle.serviceCardDescriptionTextStyle,
                                maxLines: 6,
                              ),
                              const SizedBox(height: 16),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButtonWidget.startService(
                    onPressed: () async {
                      NavigationService.navigatorKey.currentState!.pushNamed(
                          RouteName.ekramRequestTransportationScreen,
                          arguments: ekramRequestsBloc);
                    },
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
