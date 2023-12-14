import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../vd/domain/entities/map/map_screen_params.dart';
import '../../../commercial_license_exports.dart';
import '../bloc/map_bloc.dart';
import '../widgets/map_widgets/warning_message.dart';
import 'cr_map_page.dart';

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
        CommonFunctions.showError(state.errorMessage ?? "");
      }
    }, builder: (context, state) {
      print("GGG ${state.draftStatus}");
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
                        const CRHeaderDesc(header: "بيانات الموقع الجغرافي"),
                        const SizedBox(height: 12),
                        DropDownWithTitle(
                            selectedValue: state.gisResponse?.getFullAddress(),
                            title: "الموقع",
                            onTap: () async {
                              //Navigator
                              NavigationService.navigatorKey.currentState!.push(
                                MaterialPageRoute(builder: (ctx) {
                                  return BlocProvider.value(
                                      value: context.read<MapBloc>(),
                                      child: CRMapScreen());
                                }),
                              ).then((value) {
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
                          title: "المنطقه",
                        ),
                        ReadOnlyField(
                          subTitle: state.gisResponse?.municipalityName,
                          title: "الامانه",
                        ),
                        ReadOnlyField(
                          subTitle: state.gisResponse?.subMunicipalityName,
                          title: "البلديه",
                        ),
                        ReadOnlyField(
                          subTitle: state.gisResponse?.Balady_DistrictName,
                          title: "الحي",
                        ),
                        ReadOnlyField(
                          subTitle: state.gisResponse?.streetName,
                          title: "الشارع",
                        ),
                        if (state.draftStatus == BlocStatus.success) ...[
                          CustomTextFieldWidget(
                            label: "رقم المخطط",
                            hintText: "ادخل رقم المخطط",
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
                            label: "رقم قطعه الارض",
                            hintText: "ادخل رقم قطعه الارض",
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
              CRPreviousNextButtons(
                isBtnDisabled: !state.isFormValid(),
                onPressed: () {
                  context.read<MapBloc>().add(const SaveLocationDataEvent());
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
          title: "تنبيه",
          action: Row(
            children: [
              Expanded(
                child: ElevatedButtonWidget.primaryCustom(
                    text: "موافق",
                    onPressed: () {
                      NavigationService.goBack();
                    }),
              ),
            ],
          ),
          body: WarningMessage(
            message:
                " ينبغي على الراغبين بإصدار رخصة تجارية جديدة في محافظة العلا الحصول على موافقة استوديو العلا للتصميم التابع للهيئة الملكية لمحافظة العلا على التصميم الخارجي للواجهات، بما يتوافق مع الإرشادات المعمارية للمناطق الحضرية، الصادر عن الهيئة والتي يمكن معرفة المزيد عنها من خلال حجز موعد مع الاستوديو عبر الموقع الإلكتروني: https://uds.rcu.gov.sa/ ولمزيد من الاستفسارات يمكنكم التواصل مع الهيئة الملكية لمحافظة العلا عبر الرقم 920025852",
          ),
        ));
  }
}
