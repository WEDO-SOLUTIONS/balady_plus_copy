import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/presentation/intial_approval/step2/bloc/step2_activity_data_export_cubit.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/vd/domain/entities/map/map_screen_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import '../../../../../../../features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../../../../features/_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../../../../../features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../../../../../features/_shared_feature_/presentation/fields/read_only_field.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/drop_downs/drop_down_box_with_title.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/notes_widget.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../../../commercial_routes/commercial_route_names.dart';
import '../widgets/map_widgets/warning_message.dart';


class Step2IntialApprovalGeolocationData extends StatefulWidget {
  const Step2IntialApprovalGeolocationData({Key? key}) : super(key: key);

  @override
  State<Step2IntialApprovalGeolocationData> createState() => _Step2IntialApprovalGeolocationDataState();
}

class _Step2IntialApprovalGeolocationDataState extends State<Step2IntialApprovalGeolocationData> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

   // context.read<MapExportBloc>().initDraft();

    //context.read<Step2ActivityDataExportCubit>().initDraft();

  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Step2ActivityDataExportCubit, Step2ActivityDataExportState>(listener: (context, state) {
      if (state.status == BlocStatus.failure) {
        CommonFunctions.showError(state.errorMessage ?? "");
      }
    },
        builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           // CRHeaderDesc(header: "step3Title".tr()),
             SizedBox(height: state.splNotification != null?12:0),
            state.splNotification != null?
            NotesWidget(notes: [state.splNotification??""]):Container(),

             SizedBox(height: state.splNotification != null?0:12),

            DropDownWithTitle(
                selectedValue: state.gisResponse?.getFullAddress(),
                title: "loation_quest".tr(),
                onTap: () async {
                  //Navigator

                  NavigationService.navigatorKey.currentState!
                      .pushNamed(
                    CommercialRouteName.ExportMapScreen,
                    arguments: context.read<Step2ActivityDataExportCubit>(),
                  )
                      .then((value) {
                    if (value != null) {
                      MapScreenParams? params =
                          value as MapScreenParams;
                      context.read<Step2ActivityDataExportCubit>().emit(state.copyWith(
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
                controller: context.read<Step2ActivityDataExportCubit>().mapNpController,
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
                      .read<Step2ActivityDataExportCubit>()
                      .add(UpdateFieldsEvent(mapNo: value));
                },
              ),
              CustomTextFieldWidget(
                label: "parcel_number".tr(),
                hintText: "enter_parcel_no".tr(),
                controller:
                    context.read<Step2ActivityDataExportCubit>().landNpController,
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
                      .read<Step2ActivityDataExportCubit>()
                      .add(UpdateFieldsEvent(landNo: value));
                },
              )
            ],
          ],
        ),
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
