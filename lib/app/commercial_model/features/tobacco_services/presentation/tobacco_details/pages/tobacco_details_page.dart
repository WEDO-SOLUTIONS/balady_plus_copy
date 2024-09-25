import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/need_login_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/presentation/tobacco_details/mvvm/tobacco_details_view_model.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/presentation/tobacco_details/widgets/disclosed_list_widget.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/presentation/tobacco_details/widgets/disclosure_schedules_widget.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/presentation/tobacco_details/widgets/years_cards_list.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class TobaccoDetailsPage extends StatefulWidget {
  const TobaccoDetailsPage({super.key});

  @override
  State<TobaccoDetailsPage> createState() => _TobaccoDetailsPageState();
}

class _TobaccoDetailsPageState extends State<TobaccoDetailsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendUXCamEvent(UXCamEvents.openFacilityDetailsScreen);
  }

  @override
  Widget build(BuildContext context) {
    TobaccoDetailsViewModel provider =
        ModalRoute.of(context)!.settings.arguments as TobaccoDetailsViewModel;

    return ChangeNotifierProvider<TobaccoDetailsViewModel>(
      create: (BuildContext context) => provider,
      child: Scaffold(
        appBar: DefaultAppBarWidget(
          title: 'tobaccoServices'.tr(),
          bottom: const YearsCardsList(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Selector<TobaccoDetailsViewModel, bool>(
            selector: (_, provider) => provider.isLoading,
            builder: (context, isLoading, child) {
              return isLoading
                  ? ListView.builder(
                      itemCount: 2,
                      itemBuilder: (_, __) => Container(
                        height: 400,
                        margin: const EdgeInsets.only(top: 16),
                        child: const ShimmerEffectWidget(),
                      ),
                    )
                  : provider.tobaccoSchedule != null
                      ? provider.tobaccoSchedule!.disclosures.isEmpty &&
                              provider.tobaccoSchedule!.disclosures.isEmpty
                          ? EmptyListWidget(title: "no_data_shown".tr())
                          : const SingleChildScrollView(
                              child: Column(
                                children: [
                                  DisclosureSchedulesWidget(),
                                  SizedBox(height: 16),
                                  DisclosedListWidget(),
                                ],
                              ),
                            )
                      : ReloadWidget(
                          errorMessage: provider.errorMessage,
                          onTab: () {
                            provider.getUserFacilitiesDetails();
                          },
                        );
            },
          ),
        ),
      ),
    );
  }
}
