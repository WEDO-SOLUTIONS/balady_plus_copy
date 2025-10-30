import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/generic_bottom_sheet_list.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/drop_downs/drop_down_box_with_title.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import 'package:balady_plus/app/features/jod_services/presentation/models/regions.dart';
import 'package:balady_plus/app/features/jod_services/presentation/tobacco_list/mvvm/jod_donation_view_model.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/constants/ux_cam_events.dart';

class JodDonationPage extends StatefulWidget {
  const JodDonationPage({super.key});

  @override
  State<JodDonationPage> createState() => _JodDonationPageState();
}

class _JodDonationPageState extends State<JodDonationPage> {
  late JodDonationViewModel provider;

  @override
  void initState() {
    super.initState();
    provider = JodDonationViewModel(sl());
    CommonFunctions.sendUXCamEvent(UXCamEvents.startServiceDonate);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => provider,
      child: Scaffold(
        appBar: DefaultAppBarWidget(
          title: 'jod_housing'.tr(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("donating_joud_housing".tr()),
              const SizedBox(height: 22),
              Consumer<JodDonationViewModel>(
                builder: (context, provider, child) {
                  return !provider.isLoading
                      ? DropDownWithTitle(
                          title: "city_region".tr(),
                          selectedValue: provider.region?.text,
                          status: null,
                          onRetry: () {
                            // context.read<ComplianceBloc>().add(
                            //   const GetMainUsagesEvent(),
                            // );
                          },
                          onTap: () {
                            BottomSheetDialog.showDraggableSheet(
                              context,
                              dialogKeyName: DialogName.reasonCancelDialog,
                              currentRouteName: RouteName.jodDonationPage,
                              child: GenericBottomSheetList<Regions>(
                                title: "city_region".tr(),
                                items: provider.regions ?? [],
                                selectedValue: provider.region,
                                onTap: (item) {
                                  provider.selectedRegion(item);
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                        )
                      : const ShimmerEffectWidget(
                          height: 55,
                          borderRadius: 6,
                        );
                },
              ),
              const SizedBox(height: 16),
              Text("cost".tr(), style: AppStyle.sectionTitleStyle),
              const SizedBox(height: 16),
              Selector<JodDonationViewModel, double?>(
                builder: (BuildContext context, amount, Widget? child) {
                  return Row(
                    children: [
                      ActionChip(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        backgroundColor: amount == 10
                            ? AppColor.primary900Light
                            : Colors.grey.shade200,
                        label: Text(
                          '10 ${'sar'.tr()}',
                          style: AppStyle.approvedViolationLabelStyle.copyWith(
                            color: amount == 10 ? Colors.white : Colors.black,
                          ),
                        ),
                        onPressed: () {
                          provider.setAmount(10.0);
                        },
                      ),
                      const SizedBox(width: 8),
                      ActionChip(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        backgroundColor: amount == 50
                            ? AppColor.primary900Light
                            : Colors.grey.shade200,
                        label: Text(
                          '50 ${'sar'.tr()}',
                          style: AppStyle.approvedViolationLabelStyle.copyWith(
                            color: amount == 50 ? Colors.white : Colors.black,
                          ),
                        ),
                        onPressed: () {
                          provider.setAmount(50);
                        },
                      ),
                      const SizedBox(width: 8),
                      ActionChip(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        backgroundColor: amount == 100
                            ? AppColor.primary900Light
                            : Colors.grey.shade200,
                        label: Text(
                          '100 ${'sar'.tr()}',
                          style: AppStyle.approvedViolationLabelStyle.copyWith(
                            color: amount == 100 ? Colors.white : Colors.black,
                          ),
                        ),
                        onPressed: () {
                          provider.setAmount(100);
                        },
                      ),
                    ],
                  );
                },
                selector: (_, provider) => provider.amount,
              ),
              const SizedBox(height: 22),
              CustomTextFieldWidget(
                keyboardType: TextInputType.number,
                controller: provider.textController,
                onChanged: (text) {
                  if (text.isNotEmpty && double.tryParse(text) != null) {
                    provider.setAmountNotInsertTextFiled(double.parse(text));
                  }
                },
                hintText: "enter_cost".tr(),
                disabledColor: Colors.transparent,
                onValidate: (text) => (text?.isNotEmpty ?? false) &&
                        double.tryParse(text!) != null &&
                        double.parse(text) > 0 &&
                        double.parse(text) <= 1000000
                    ? null
                    : "required_field_must_number_jod".tr(),
              ),
              const SizedBox(height: 12),
              Text("donation_automatically_neediest".tr()),
              const SizedBox(height: 12),
              const Row(
                children: [
                  CustomSvgIconWidget(IconPath.masterCardIcon, iconSize: 25),
                  SizedBox(width: 12),
                  CustomSvgIconWidget(IconPath.visaIcon, iconSize: 20),
                  SizedBox(width: 12),
                  CustomSvgIconWidget(IconPath.madaIcon, iconSize: 20),
                  SizedBox(width: 12),
                  CustomSvgIconWidget(IconPath.applePayIcon, iconSize: 40),
                ],
              ),
              const SizedBox(height: 22),
              Selector<JodDonationViewModel, bool>(
                builder: (BuildContext context, isLoading, Widget? child) {
                  return isLoading
                      ? const ShimmerEffectWidget(
                          height: 60,
                          borderRadius: 8,
                        )
                      : child!;
                },
                selector: (_, provider) => provider.isLoading,
                child: ElevatedButtonWidget.primaryCustom(
                  onPressed: () async {
                    NavigatorState navigator = Navigator.of(context);
                    if (provider.region != null) {
                      if ((provider.amount != null && provider.amount != 0)) {
                        String? url = await provider
                            .getJoodEskanServicesGenerateDonationUrl();
                        if (url != null) {
                          CommonFunctions.sendUXCamEvent(
                            UXCamEvents.openWebDonateScreen,
                          );
                          navigator.pushNamed(
                            RouteName.inappWebview,
                            arguments: (
                              requestNum: "jod".tr(),
                              url: url,
                              isObjections: false,
                            ),
                          );
                        }
                      } else {
                        CommonFunctions.showError(
                            'you_must_choose_amount'.tr());
                      }
                    } else {
                      CommonFunctions.showError('select_region'.tr());
                    }
                  },
                  text: 'donate'.tr(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
