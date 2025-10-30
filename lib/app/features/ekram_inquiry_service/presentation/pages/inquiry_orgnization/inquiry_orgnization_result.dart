import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import '../../bloc/inquiry_orgnizations_bloc/ekram_inquiry_orgnization_state.dart';
import '../../bloc/inquiry_orgnizations_bloc/ekram_inquiry_orgnization_bloc.dart';
import '../../bloc/inquiry_orgnizations_bloc/ekram_inquiry_orgnization_event.dart';
import '../../widgets/inquiry_orgnization/orgnization_details_item_widget.dart';

class InquiryOrgnizationResultsPage extends StatefulWidget {
  const InquiryOrgnizationResultsPage({super.key});

  @override
  State<InquiryOrgnizationResultsPage> createState() =>
      _InquiryOrgnizationResultsPageState();
}

class _InquiryOrgnizationResultsPageState
    extends State<InquiryOrgnizationResultsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.finishServiceFuneralServiceInquiry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: "Search_SearchResult".tr(),
        x: true,
      ),
      body: BlocProvider.value(
        value: ModalRoute.of(context)!.settings.arguments
            as EkramInquiryOrgnizationBloc,
        child: BlocConsumer<EkramInquiryOrgnizationBloc,
            EkramOrgnizationCemetryState>(
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
                        itemCount: state.charityOrgnizations!.length,
                        itemBuilder: (ctx, index) {
                          return OrgnizationDetailsItemWidget(
                            item: state.charityOrgnizations![index],
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
                              context
                                  .read<EkramInquiryOrgnizationBloc>()
                                  .add(const ClearEvent());
                              NavigationService.navigatorKey.currentState!
                                  .pop(context);
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
