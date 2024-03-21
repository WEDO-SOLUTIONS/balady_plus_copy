import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:localize_and_translate/localize_and_translate.dart';


import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import '../../../_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import '../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';

import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../domain/entity/permits_response_entity.dart';
import '../bloc/license_permits_cubit.dart';

class PremitsScreen extends StatefulWidget {
  const PremitsScreen({Key? key}) : super(key: key);

  @override
  State<PremitsScreen> createState() => _PremitsScreenState();
}

class _PremitsScreenState extends State<PremitsScreen> {
  LicensePermitsCubit? bloc;
  String? licenseNumber;

  @override
  void initState() {
    super.initState();

    // commercialLicenseNumber = 45079837078;
    // unifiedFacilityNumber = 7008360062;

    Future.microtask(() {
      setState(() {
        licenseNumber = "${bloc!.licenseNumber}#";
      });
      bloc!.getLicensePermitsDetails(bloc!.licenseNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        bloc = ModalRoute.of(context)!.settings.arguments
        as LicensePermitsCubit;

        return bloc!;
      },
      child: Scaffold(
        backgroundColor: AppColor.scaffoldBackground,
        resizeToAvoidBottomInset: true,
        appBar: DefaultAppBarWidget(
          title: "back".tr(),
          showBack: true,

        ),
        body: getBody(),


      ),
    );
  }

  Widget getBody() {
    return BlocConsumer<LicensePermitsCubit,
        LicensePermitsState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (_, state) async {
        // if (state.status == BlocRequestStatus.submissionGetFailure) {
        //   MessageDialog.showErrorNotification(msg: state.error);
        // }
      },
      builder: (context, state) {
        if (state.status == BlocRequestStatus.submissionGetLoading) {
          return ListView.builder(
            itemCount: 3,
            itemBuilder: (_, __) => Container(
              height: 200,
              margin: const EdgeInsets.only(top: 16),
              child: const ShimmerEffectWidget(),
            ),
          );
        }


        else if (state.licencePermitsResponse != null) {
          final permitResponse = state.licencePermitsResponse!;
          return Padding(
            padding: const EdgeInsets.only(left: 15.0,right: 15,top: 20),
            child: ListView.builder(
                shrinkWrap: true,
                physics:
                const NeverScrollableScrollPhysics(),
                itemCount: permitResponse
                    .permits!.length,
                itemBuilder: (_, index) {
                  PermitEntity permit =
                  permitResponse
                      .permits![index];
                  return
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const DrawIconBasedTypeWidget(
                                  icon: IconPath.documentCopy,
                                  iconSize: 24,
                                ),

                                CustomTextWidget(
                                  '${permit.permitName}',
                                  textStyle: AppStyle.dateTextStyle,
                                ),
                                const Spacer(),
                                CustomElevatedButtonWidget(
                                  btnColor: AppColor.blueSkyLight800,
                                  textStyle: AppStyle.elevatedButtonStyle.copyWith(
                                    color: AppColor.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                  btnPadding: EdgeInsets.all(8.0),
                                  btnHeight: 30,
                                  btnWidth: 20,
                                  text: "tranfer_permit".tr(),
                                  onPressed: (){


                                  },
                                )


                              ],
                            ),

                            const SizedBox(height: 30),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      CustomTextWidget(
                                        "permit_24_permit_no".tr(),
                                        textStyle: AppStyle.tagTextStyle,
                                      ),
                                      const SizedBox(height: 4),
                                      CustomTextWidget(
                                        "${permit.permitNumber}",
                                        textStyle:
                                        AppStyle.costTitleTextStyle,
                                        maxLines: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      CustomTextWidget(
                                        "expirationDate".tr(),
                                        textStyle: AppStyle.tagTextStyle,
                                      ),
                                      const SizedBox(height: 4),
                                      CustomTextWidget(
                                        permit.expirationDate!,
                                        textStyle:
                                        AppStyle.costTitleTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                },
              ),
          );
        }
        return Center(
          child: ReloadWidget(
            errorMessage: "no_data_found".tr(),
            onTab: () {
              bloc!.getLicensePermitsDetails(
                  bloc!.licenseNumber);
            },
          ),
        );
      },
    );
  }
}
