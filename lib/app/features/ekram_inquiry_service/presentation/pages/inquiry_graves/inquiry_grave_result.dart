import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/ekram_inquiry_service/presentation/bloc/inquiry_cemetry_bloc/ekram_inquiry_cemetry_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import '../../bloc/inquiry_cemetry_bloc/ekram_inquiry_cemetry_bloc.dart';
import '../../bloc/inquiry_grave_bloc/ekram_inquiry_grave_bloc.dart';
import '../../bloc/inquiry_grave_bloc/ekram_inquiry_grave_state.dart';
import '../../widgets/inquiry_cemetry/cemetry_details_item_widget.dart';
import '../../widgets/inquiry_graves/grave_details_item_widget.dart';

class InquiryGraveResultsPage extends StatefulWidget {
  const InquiryGraveResultsPage({super.key});

  @override
  State<InquiryGraveResultsPage> createState() =>
      _InquiryGraveResultsPageState();
}

class _InquiryGraveResultsPageState extends State<InquiryGraveResultsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(UXCamEvents.finishServiceGraveInquiry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: "Search_SearchResult".tr(),
        x: true,
      ),
      body: BlocProvider.value(
        value:
            ModalRoute.of(context)!.settings.arguments as EkramInquiryGraveBloc,
        child: BlocConsumer<EkramInquiryGraveBloc, EkramInquiryGraveState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.findGraveResponse!.length,
                        itemBuilder: (ctx, index) {
                          return GraveDetailsItemWidget(
                            item: state.findGraveResponse![index],
                          );
                        }),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: AppColor.scaffoldBackground,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButtonWidget.primaryCustomBorder(
                            onPressed: () {
                              NavigationService.navigatorKey.currentState!
                                  .pop(context);
                              NavigationService.navigatorKey.currentState!
                                  .pushReplacementNamed(
                                      RouteName.EkramInquiryGravesDetailsPage);
                            },
                            text: "another_search".tr(),
                          ),
                          const CustomVerticalSpace(height: 16),
                          ElevatedButtonWidget.primaryCustom(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            text: "return_to_services_page".tr(),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
