
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../domain/entity/commercial_license_data_entity.dart';
import '../bloc/commercial_license_query_details_cubit.dart';

class CommercialLicenseQueryDetails extends StatefulWidget {
  const CommercialLicenseQueryDetails({super.key});

  @override
  State<CommercialLicenseQueryDetails> createState() =>
      _CommercialLicenseQueryDetailsState();
}

class _CommercialLicenseQueryDetailsState
    extends State<CommercialLicenseQueryDetails> {

  CommercialLicenseQueryDetailsCubit? bloc;


  @override
  void initState() {
    super.initState();

    // commercialLicenseNumber = 45079837078;
    // unifiedFacilityNumber = 7008360062;


    Future.microtask(() {
      bloc!.getCommercialLicenseQueryDetails(bloc!.commercialLicenseNumber, bloc!.unifiedFacilityNumber);

    });

  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_){
        bloc= ModalRoute.of(context)!
            .settings
            .arguments as CommercialLicenseQueryDetailsCubit;

        return bloc!;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: AppColor.scaffoldBackground,
          elevation: 0,
          shadowColor: AppColor.primary100Light,
          centerTitle: false,
          title: CustomTextWidget(
            "#${bloc?.commercialLicenseNumber}?''",
            fontSize: 14,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
            fontWeight: AppFontWeight.medium,
            fontColor: AppColor.blackModern700Light,
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: getBody(),
        ),
      ),
    );


  }





  Widget getBody()
  {
    return  BlocConsumer<CommercialLicenseQueryDetailsCubit,
        CommercialLicenseQueryDetailsState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (_, state) async {
        if (state.status == BlocRequestStatus.submissionGetFailure) {
          MessageDialog.showErrorNotification(msg: state.error);
        }
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
        } else if (state.commercialLicenceQueryDetails != null) {
          final commercialLicenceQueryDetails = state.commercialLicenceQueryDetails!;
          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    const DrawIconBasedTypeWidget(
                      icon: IconPath.calendar,
                      iconSize: 24,
                    ),
                    const SizedBox(width: 4),
                    CustomTextWidget(
                      'date',
                      textStyle: AppStyle.dateTextStyle,
                    ),
                    const Spacer(),
                    Container(
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColor.primary50Light,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            CustomTextWidget(
                              commercialLicenceQueryDetails.licenseStatus?.name ?? "",
                              textStyle: AppStyle.tagTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                ExpandableCard(
                  title: 'license_info'.tr(),
                  icon: IconPath.editIcon,
                  isExpandedByDefault: false,
                  children: [
                    CardParameter(
                      title: 'cr_Number'.tr(),
                      value: commercialLicenceQueryDetails.licenseNumber.toString() ?? '',
                      bgColor: AppColor.mystic,
                    ),
                    CardParameter(
                      title: 'facilityType'.tr(),
                      value: commercialLicenceQueryDetails.entityType ?? '',
                      bgColor: AppColor.mystic,
                    ),
                    CardParameter(
                      title: 'employee_type'.tr(),
                      value: commercialLicenceQueryDetails.workerType ?? "",
                      bgColor: AppColor.mystic,
                    ),

                    commercialLicenceQueryDetails.shopNameAr  != null? CardParameter(
                      title: 'license_shop_name_ar'.tr(),
                      value: commercialLicenceQueryDetails.shopNameAr ?? '',
                      bgColor: AppColor.mystic,
                    ):Container(),
                    /////////////////////
                    commercialLicenceQueryDetails.shopNameEn  != null?
                        CardParameter(
                      title: 'license_shop_name_en'.tr(),
                      value: commercialLicenceQueryDetails.shopNameEn ?? '',
                      bgColor: AppColor.mystic,
                    ):Container(),
                    CardParameter(
                      title: 'city'.tr(),
                      value: commercialLicenceQueryDetails.city?.name?? '',
                      bgColor: AppColor.mystic,
                    ),
                    CardParameter(
                      title: 'district'.tr(),
                      value: commercialLicenceQueryDetails.district?.name ?? '',
                      bgColor: AppColor.mystic,
                    ),
                    const SizedBox(height: 16),
                    commercialLicenceQueryDetails.x !=
                        null &&
                        commercialLicenceQueryDetails
                            .y !=
                            null
                        ?
                    SizedBox(
                      height: 250,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                              double.parse(
                                  commercialLicenceQueryDetails
                                      .x!),
                              double.parse(
                                  commercialLicenceQueryDetails
                                      .y!),
                            ),
                            zoom: 16),
                        markers: {
                          Marker(
                            markerId: const MarkerId('position'),
                            position: LatLng(
                              double.parse(
                                  commercialLicenceQueryDetails
                                      .x!),
                              double.parse(
                                  commercialLicenceQueryDetails
                                      .y!),
                            ),
                          )
                        },
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: false,
                        scrollGesturesEnabled: false,
                      ),
                    )
                        : const SizedBox(),


                  ],
                ),



                commercialLicenceQueryDetails.mainActivity != null
                    ? ExpandableCard(
                  title: 'activity_info'.tr(),
                  icon: IconPath.editIcon,
                  children: [
                    CardParameter(
                      title: 'isicNumber'.tr(),
                      value: commercialLicenceQueryDetails.mainActivity!.isicNumber.toString(),
                      bgColor: AppColor.mystic,
                    ),
                    CardParameter(
                      // from whats
                      title: 'isicName'.tr(),
                      value: commercialLicenceQueryDetails.mainActivity!.isicName.toString(),
                      bgColor: AppColor.mystic,
                    ),
                    commercialLicenceQueryDetails.additionalActivities
                        !=
                        null
                        ?
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20,),
                        CustomTextWidget(
                          'additional_activity_info'.tr(),
                          textStyle: AppStyle.cardTitleTextStle.copyWith(fontSize: 16),
                          maxLines: 2,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics:
                          const NeverScrollableScrollPhysics(),
                          itemCount: commercialLicenceQueryDetails
                              .additionalActivities!.length,
                          itemBuilder: (_, index) {
                            LicenseActivity activity = commercialLicenceQueryDetails.additionalActivities![index];
                            return
                              ExpandableCard(
                                title: activity.detailedActivityName!,
                                bgColor: AppColor.lightGray,
                                children: [

                                  CardParameter(
                                    title: 'extra_isicNumber'.tr(),
                                    value: activity.isicNumber.toString(),
                                    bgColor: AppColor.lightGray,
                                  ),
                                  const Divider(height: 2,color:AppColor.blackModern200Light ,),
                                  CardParameter(
                                    // from whats
                                    title: 'extra_isicName'.tr(),
                                    value:activity.isicName.toString(),
                                    bgColor: AppColor.lightGray,
                                  ),
                                ],

                              );

                            ;
                          },
                        ),
                      ],
                    )
                        : const SizedBox(),
                  ],
                )
                    : const SizedBox(),






                // commercialLicenceQueryDetails.activityInfo!.additionalActivities !=
                //     null
                //     ? ExpandableCard(
                //   title: 'list_additional_activities'.tr(),
                //   icon: IconPath.editIcon,
                //   children: [
                //     Column(
                //       children: commercialLicenceQueryDetails
                //           .activityInfo!.additionalActivities!
                //           .map(
                //             (e) => Card(
                //           margin: const EdgeInsets.all(8),
                //           child: Column(
                //             children: [
                //               CardParameter(
                //                 title: 'isicActivityName_sub'.tr(),
                //                 value: e.isicActivityName,
                //               ),
                //               CardParameter(
                //                 title: 'detailedActivityName'.tr(),
                //                 value: e.detailedActivityName,
                //               ),
                //               CardParameter(
                //                 title: 'isicActivityName'.tr(),
                //                 value: e.area.toString(),
                //               ),
                //             ],
                //           ),
                //         ),
                //       )
                //           .toList(),
                //     ),
                //   ],
                // )
                //     : const SizedBox(),

                const SizedBox(height: 24),
              ],
            ),
          );
        }
        return Center(
          child: ReloadWidget(
            onTab: () {
              bloc!.getCommercialLicenseQueryDetails(bloc!.commercialLicenseNumber, bloc!.unifiedFacilityNumber);
            },
          ),
        );
      },
    );
  }

}
