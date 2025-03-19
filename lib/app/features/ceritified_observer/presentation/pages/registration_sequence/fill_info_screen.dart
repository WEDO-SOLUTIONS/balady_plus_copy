import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_style.dart';
import '../../../../_shared_feature_/presentation/cards/expandable_card.dart';
import '../../../../_shared_feature_/presentation/fields/read_only_field.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../../domain/entity/register_observer_request.dart';
import '../../blocs/choose_muncipality_bloc.dart';

class FillInfoScreen extends StatefulWidget {
  const FillInfoScreen({Key? key}) : super(key: key);

  @override
  State<FillInfoScreen> createState() => _FillInfoScreenState();
}

class _FillInfoScreenState extends State<FillInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseMuncipalityBloc, CertifiedObserverState>(
      builder: (context, state) {
        if (state is ChooseMuncipalityState) {
          return SingleChildScrollView(
            child: Column(
              children: [
                ExpandableCard(
                  title: 'user_data_applicant'.tr(),
                  children: [
                    const SizedBox(height: 20),
                    ReadOnlyField(
                      hieght: 55,
                      title: "user_data_applicant_id".tr(),
                      subTitle: CommonProperties.userInfo?.idNo,
                      subTitleColor: AppColor.grey1000.withOpacity(0.5),
                      decoration: BoxDecoration(
                        color: AppColor.blackModern300Light.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    ReadOnlyField(
                      hieght: 55,
                      title: "user_data_applicant_name".tr(),
                      subTitle: CommonProperties.userInfo?.arName,
                      subTitleColor: AppColor.grey1000.withOpacity(0.5),
                      decoration: BoxDecoration(
                        color: AppColor.blackModern300Light.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    )
                  ],
                ),
                ExpandableCard(
                  title: 'location'.tr(),
                  children: [
                    CustomLookUpLongDialog(
                      showOptional: false,
                      isDisbaled: true,
                      items: state.lstMunicipalityLookUp ?? [],
                      value: state.getMuncipalityById(
                          state.requestData?.municipalityID),
                      onEmptyList: () async {},
                      onChangeType: (LookUpItem? item) {
                        if (item != null) {}
                      },
                      label: "license_health_municipality".tr(),
                      hint: "license_health_municipality".tr(),
                    ),
                    CustomLookUpLongDialog(
                      showOptional: false,
                      items: state.lstCitesLookUp ?? [],
                      value: state.getCityById(state.requestData?.cityCode),
                      onEmptyList: () async {
                        return context
                            .read<ChooseMuncipalityBloc>()
                            .getCityList();
                      },
                      onChangeType: (LookUpItem? item) {
                        if (item != null) {
                          context.read<ChooseMuncipalityBloc>().add(
                              setRequestDataEvent(
                                  dataModel: RegisterObserverRequest(
                                      cityCode: item.strId)));
                        }
                      },
                      label: "city".tr(),
                      hint: "city".tr(),
                    ),
                    CustomLookUpLongDialog(
                      showOptional: false,
                      items: state.lstDegrees ?? [],
                      value: state.getDegreeByName(
                          state.requestData?.academicQualification),
                      onEmptyList: () async {
                        return context
                            .read<ChooseMuncipalityBloc>()
                            .getDegreeList();
                      },
                      onChangeType: (LookUpItem? item) {
                        if (item != null) {
                          context.read<ChooseMuncipalityBloc>().add(
                                setRequestDataEvent(
                                  dataModel: RegisterObserverRequest(
                                    academicQualification: item.name,
                                  ),
                                ),
                              );
                        }
                      },
                      label: "degree".tr(),
                      hint: "degree".tr(),
                    ),
                  ],
                ),
                ExpandableCard(
                  title: 'vd_user_info'.tr(),
                  children: [
                    const SizedBox(height: 20),
                    CustomLookUpLongDialog(
                      showOptional: false,
                      items: state.lstDegrees ?? [],
                      value: state.getDegreeByName(
                          state.requestData?.academicQualification),
                      onEmptyList: () async {
                        return context
                            .read<ChooseMuncipalityBloc>()
                            .getDegreeList();
                      },
                      onChangeType: (LookUpItem? item) {
                        if (item != null) {
                          context.read<ChooseMuncipalityBloc>().add(
                                setRequestDataEvent(
                                  dataModel: RegisterObserverRequest(
                                    academicQualification: item.name,
                                  ),
                                ),
                              );
                        }
                      },
                      label: "degree".tr(),
                      hint: "degree".tr(),
                    ),
                    CustomLookUpLongDialog(
                      showOptional: false,
                      items: state.lstMaritalStatus ?? [],
                      value: state.getMaritalStatusByName(
                          state.requestData?.maritalStatus),
                      onEmptyList: () async {
                        return context
                            .read<ChooseMuncipalityBloc>()
                            .getMaritalStatusList();
                      },
                      onChangeType: (LookUpItem? item) {
                        if (item != null) {
                          context.read<ChooseMuncipalityBloc>().add(
                                setRequestDataEvent(
                                  dataModel: RegisterObserverRequest(
                                    maritalStatus: item.name,
                                  ),
                                ),
                              );
                        }
                      },
                      label: "marital_status".tr(),
                      hint: "marital_status".tr(),
                    ),
                  ],
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36),
                    ),
                    color: Colors.white,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
                  child: CustomElevatedButtonWidget(
                    btnColor: AppColor.primary800Light,
                    textStyle: AppStyle.elevatedButtonStyle.copyWith(
                      color: AppColor.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    btnHeight: 56,
                    text: "next".tr(),
                    onPressed: () {
                      if (state.requestData?.municipalityID != null) {
                        context
                            .read<ChooseMuncipalityBloc>()
                            .checkMuncipalityAcceptance();
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
