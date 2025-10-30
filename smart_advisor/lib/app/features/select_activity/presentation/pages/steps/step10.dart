import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';
import 'package:smart_advisor/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:smart_advisor/app/features/home_page/presentation/widgets/widgetsNew/city_dialog.dart';
import 'package:smart_advisor/app/features/select_activity/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_style.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_drop_down.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_drop_down_text.dart';
import '../../../../map/domain/entities/gis_data_request.dart';
import '../../../../map/domain/entities/gis_data_response.dart';
import '../../../domain/entities/activity_details_page_params.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:dgis_map/library.dart';

class Step10Page extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlocBuilder<MainFlowBloc, MainFlowState>(
      //buildWhen: (previous, current) =>
      //previous.permitsStatus != current.permitsStatus ||
      //     previous.status != current.status,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(
            right: 16.0,
            left: 16,
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'هل قمت بتحديد موقع المحل/المنشأة المراد ترخيصها؟',
                  textAlign: TextAlign.start,
                  style: AppStyle.somarSemiBold
                      .copyWith(color: AppColor.textPrimaryColor),
                ),
                // const SizedBox(height: 4),
                Text(
                  'الموقع الذي ستقوم بمزاولة النشاط فيه',
                  textAlign: TextAlign.center,
                  style: AppStyle.textRegularStyle
                      .copyWith(color: AppColor.textSecondaryColor),
                ),
                const SizedBox(height: 24),

                // Option buttons
                Row(
                  children: [
                    Expanded(
                      child: OptionButton(
                        text: 'نعم',
                        description: 'أعرف أين سأقوم بممارسة النشاط',
                        isSelected: state.locationOption == 'yes',
                        onTap: () {
                          context
                              .read<MainFlowBloc>()
                              .add(ChangeValuesEvent(locationOption: "yes"));
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OptionButton(
                        text: 'لا',
                        description: 'لم أقم بتحديد الموقع بعد',
                        isSelected: state.locationOption == 'no',
                        onTap: () {
                          context
                              .read<MainFlowBloc>()
                              .add(ChangeValuesEvent(locationOption: "no"));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                if (state.locationOption == "yes") ...[
                  Text(
                    'الموقع',
                    style: AppStyle.textRegularRomanStyle
                        .copyWith(color: AppColor.textPrimaryColor),
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  // Location button
                  GestureDetector(
                    onTap: () {
                      NavigationService.navigatorKey.currentState!
                          .pushNamed(RouteName.mapPage,
                              arguments: ActivityDetailsPageParams(
                                  sector: state.selectedSector,
                                  activityId: state.selectedActivity))
                          .then((value) {
                        if (value != null) {
                          var item = value as (GisDataResponse, GISDataRequest);
                          context.read<MainFlowBloc>().add(ChangeValuesEvent(
                              gisDataRequest: item.$2,
                              gisDataResponse: item.$1));
                        }
                      });
                    },
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.only(
                          top: 16, bottom: 16, right: 13, left: 13),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              state.gisResponse?.getFullAddress() ??
                                  'حدد الموقع من الخريطة',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyle.textRegularRomanStyle
                                  .copyWith(color: AppColor.textSecondaryColor),
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          SvgPicture.asset(
                              'packages/smart_advisor/smart_advisor_assets/icons/svg/grayarrow.svg'),
                        ],
                      ),
                    ),
                  ),
                ],

                if (state.locationOption == "no") ...[
                  if (state.citiesStatus == BlocStatus.failure)
                    ReloadWidget(onTab: () {
                      context.read<MainFlowBloc>().add(const GetCitiesEvent());
                    }),

                  if (state.citiesStatus == BlocStatus.success)
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: const Color(0xff000000),
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext ctx) => CityDialog(
                              items: state.cities ?? [],
                              title: 'المدينة',
                              selection: state.selectedCity,
                              onSelection: (LookUpItem? selectedCity) {
                                context
                                    .read<MainFlowBloc>()
                                    .add(GetDistricts(city: selectedCity!));

                                Navigator.pop(context);
                              }),
                        );
                      },
                      child: CustomDropdownText(
                        title: 'اختر المدينة',
                        selectedItem: state.selectedCity,
                        list: state.cities ?? [],
                      ),
                    ),

                  const SizedBox(
                    height: 12,
                  ),
                  if (state.districtsStatus == BlocStatus.success)
                    GestureDetector(
                      onTap: () async {
                        showModalBottomSheet(
                          backgroundColor: const Color(0xff000000),
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext ctx) => CityDialog(
                              items: state.districts ?? [],
                              title: 'الحي',
                              selection: state.selectedDistrict,
                              onSelection: (LookUpItem? selectedCity) async {
                                context.read<MainFlowBloc>().add(
                                    ChangeValuesEvent(district: selectedCity));

                                final dgisController = await ref
                                    .read(dgisControllerProvider.future);

                                SearchResultMessage? f =
                                    await dgisController.search(
                                        "${selectedCity?.name}, ${state.selectedCity?.name}",
                                        sortingType:
                                            SortingTypeMessage.byRelevance);
                                print(f.firstPage?.items.first?.markerPosition);

                                if (f.firstPage?.items.first?.markerPosition
                                        ?.longitude !=
                                    null)
                                  context
                                      .read<MainFlowBloc>()
                                      .add(
                                          GetGISDataEvent(
                                              lat: f
                                                      .firstPage
                                                      ?.items
                                                      .first
                                                      ?.markerPosition
                                                      ?.latitude ??
                                                  0,
                                              lon: f
                                                      .firstPage
                                                      ?.items
                                                      .first
                                                      ?.markerPosition
                                                      ?.longitude ??
                                                  0));
                                context.read<MainFlowBloc>().emit(state
                                    .copyWith(
                                        selectedDistrict: selectedCity,
                                        gisResponse: GisDataResponse(
                                            districtName: selectedCity?.name),
                                        request: GISDataRequest(
                                            lat: f
                                                    .firstPage
                                                    ?.items
                                                    .first
                                                    ?.markerPosition
                                                    ?.latitude ??
                                                0,
                                            lon: f
                                                    .firstPage
                                                    ?.items
                                                    .first
                                                    ?.markerPosition
                                                    ?.longitude ??
                                                0)));
                                Navigator.pop(context);
                              }),
                        );
                      },
                      child: CustomDropdownText(
                        title: 'اختر الحي',
                        selectedItem: state.selectedDistrict,
                        list: state.districts ?? [],
                      ),
                    ),

                  /*    GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.only(
                          top: 16, bottom: 16, right: 13, left: 13),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'الرياض',
                            style: AppStyle.textRegularRomanStyle
                                .copyWith(color: AppColor.textSecondaryColor),
                          ),
                          SvgPicture.asset(
                              'packages/smart_advisor/smart_advisor_assets/icons/svg/arrowdaown.svg'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),

                Text(
                    'الحي',
                    style: AppStyle.textRegularRomanStyle
                        .copyWith(color: AppColor.textPrimaryColor),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.only(
                          top: 16, bottom: 16, right: 13, left: 13),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'حي العليا',
                            style: AppStyle.textRegularRomanStyle
                                .copyWith(color: AppColor.textSecondaryColor),
                          ),
                          SvgPicture.asset(
                              'packages/smart_advisor/smart_advisor_assets/icons/svg/arrowdaown.svg'),
                        ],
                      ),
                    ),
                  ),*/
                  // You can add additional logic or widgets for the 'no' option here.
                ],
                /*   GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: const Color(0xff000000),
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) =>
                            const CityDialog(items: [], selection: state.sele),
                      );
                    },
                    child: Text('data')),*/

                const Spacer(),
              ]),
        );
      },
    );
  }
}

class OptionButton extends StatelessWidget {
  final String text;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionButton({
    Key? key,
    required this.text,
    required this.description,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 113,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColor.primary : Colors.white,
            width: 2,
          ),
          color: isSelected ? Colors.white : Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: AppStyle.textRegularRomanStyle
                  .copyWith(color: AppColor.textPrimaryColor),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: AppStyle.footNoteMediumStyle
                  .copyWith(color: AppColor.textSecondaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
