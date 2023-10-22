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

class CRStep3GeolocationData extends StatelessWidget {
  const CRStep3GeolocationData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(builder: (context, state) {
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
                              await NavigationService.navigatorKey.currentState!
                                  .pushNamed(RouteName.crMapScreen,
                                      arguments: MapScreenParams(
                                        gisParams: state.location,
                                        gisResponse: state.gisResponse,
                                      ))
                                  .then((value) {
                                if (value != null) {
                                  MapScreenParams? params =
                                      value as MapScreenParams;
                                  context.read<MapBloc>().emit(state.copyWith(
                                      gisResponse: params.gisResponse,
                                      location: params.gisParams));
                                }
                              });
                            }),
                        ReadOnlyField(
                          subTitle: state.gisResponse?.region,
                          title: "المنطقه",
                        ),
                        ReadOnlyField(
                          subTitle: state.gisResponse?.adminMunicipalityName,
                          title: "الامانه",
                        ),
                        ReadOnlyField(
                          subTitle: state.gisResponse?.municipalityName,
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
                        CustomTextFieldWidget(
                          label: "رقم المخطط",
                          hintText: "ادخل رقم المخطط",
                          controller: context.read<MapBloc>().mapNpController,
                          isDigitsOnly: true,
                          keyboardType: TextInputType.number,
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
                          controller: context.read<MapBloc>().landNpController,
                          isDigitsOnly: true,
                          keyboardType: TextInputType.number,
                          bottomMargin: 24,
                          onChanged: (value) {
                            context
                                .read<MapBloc>()
                                .add(UpdateFieldsEvent(landNo: value));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              CRPreviousNextButtons(
                isBtnDisabled: state.gisResponse == null,
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
}
