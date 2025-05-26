import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/vd/domain/entities/map/map_screen_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';
import '../bloc/map_bloc.dart';
import '../widgets/map_widgets/warning_message.dart';

class CRStep3GeolocationData extends StatefulWidget {
  const CRStep3GeolocationData({Key? key}) : super(key: key);

  @override
  State<CRStep3GeolocationData> createState() => _CRStep3GeolocationDataState();
}

class _CRStep3GeolocationDataState extends State<CRStep3GeolocationData> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<MapBloc>().initDraft();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapState>(listener: (context, state) {
      if (state.status == BlocStatus.failure) {
        CommonFunctions.showError(state.errorMessage ?? "",true);
      }


    }, builder: (context, state) {
      return Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CRHeaderDesc(header: "step3Title".tr()),
                        state.splNotification != null?
                        NotesWidget(notes: [state.splNotification??""],showText: true,marginBottom: 0,):Container(),
                        SizedBox(height: state.splNotification != null?0:12),
                        DropDownWithTitle(
                            selectedValue: state.gisResponse?.getFullAddress(),
                            title: "loaction".tr(),
                            onTap: () async {
                              //Navigator

                              NavigationService.navigatorKey.currentState!
                                  .pushNamed(
                                RouteName.crMapScreen,
                                arguments: context.read<MapBloc>(),
                              )
                                  .then((value) {
                                if (value != null) {
                                  MapScreenParams? params =
                                      value as MapScreenParams;
                                  context.read<MapBloc>().emit(state.copyWith(
                                      gisResponse: params.gisResponse,
                                      location: params.gisParams,
                                      mapNo:
                                          params.gisResponse?.planNo != "Null"
                                              ? params.gisResponse?.planNo ?? ""
                                              : "",
                                      landNo: params.gisResponse?.parcelNo !=
                                              "Null"
                                          ? params.gisResponse?.parcelNo ?? ""
                                          : ""));

                                  if (params.gisResponse?.municipalityId ==
                                      "003201") {
                                    showOlaMessage();
                                  }
                                }
                              });
                            }),
                        ReadOnlyField(
                          subTitle: state.gisResponse?.region,
                          title: "region".tr(),
                        ),
                        ReadOnlyField(
                          subTitle: state.gisResponse?.municipalityName,
                          title: "municipalityName".tr(),
                        ),
                        ReadOnlyField(
                          subTitle: state.gisResponse?.subMunicipalityName,
                          title: "subMunicipalityName".tr(),
                        ),
                        ReadOnlyField(
                          subTitle: state.gisResponse?.Balady_DistrictName,
                          title: "district".tr(),
                        ),
                        ReadOnlyField(
                          subTitle: state.gisResponse?.streetName,
                          title: "street".tr(),
                        ),
                        if (state.draftStatus == BlocStatus.success) ...[
                          CustomTextFieldWidget(
                            label: "planNumber".tr(),
                            hintText: "enter_plan_number".tr(),
                            controller: context.read<MapBloc>().mapNpController,
                            isDigitsOnly: false,
                            fillColor:
                                (state.gisResponse?.planNo?.isEmpty ?? true) ||
                                        state.gisResponse?.planNo == "Null"
                                    ? Colors.white
                                    : Colors.transparent,
                            enabled:
                                (state.gisResponse?.planNo?.isEmpty ?? true) ||
                                    state.gisResponse?.planNo == "Null",
                            keyboardType: TextInputType.text,
                            bottomMargin: 24,
                            onChanged: (value) {
                              context
                                  .read<MapBloc>()
                                  .add(UpdateFieldsEvent(mapNo: value));
                            },
                          ),
                          CustomTextFieldWidget(
                            label: "parcel_number".tr(),
                            hintText: "enter_parcel_no".tr(),
                            controller:
                                context.read<MapBloc>().landNpController,
                            isDigitsOnly: false,
                            fillColor: (state.gisResponse?.parcelNo?.isEmpty ??
                                        true) ||
                                    state.gisResponse?.parcelNo == "Null"
                                ? Colors.white
                                : Colors.transparent,
                            enabled: (state.gisResponse?.parcelNo?.isEmpty ??
                                    true) ||
                                state.gisResponse?.parcelNo == "Null",
                            keyboardType: TextInputType.text,
                            bottomMargin: 24,
                            onChanged: (value) {
                              context
                                  .read<MapBloc>()
                                  .add(UpdateFieldsEvent(landNo: value));
                            },
                          )
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              (state.status.isSubmissionLoading)
                  ? const Center(child: CustomCircularLoadingWidget())
                  : CRPreviousNextButtons(
                      isBtnDisabled: !state.isFormValid(),
                      onPressed: () {
                        context
                            .read<MapBloc>()
                            .add(const SaveLocationDataEvent());
                      },
                    ),
            ],
          ),
          if (state.status.isSubmissionLoading)
            const CustomCircularLoadingWidget(),
        ],
      );
    });
  }

  void showOlaMessage() {
    BottomSheetDialog.showDraggableSheet(
        NavigationService.navigatorKey.currentContext!,
        child: BottomSheetWithActions(
          title: "cancelLicenseWarningTitleWord".tr(),
          action: Row(
            children: [
              Expanded(
                child: ElevatedButtonWidget.primaryCustom(
                    text: "agree".tr(),
                    onPressed: () {
                      NavigationService.goBack();
                    }),
              ),
            ],
          ),
          body: WarningMessage(
            message: "cr_geolocation_warning".tr(),
          ),
        ));
  }
}
