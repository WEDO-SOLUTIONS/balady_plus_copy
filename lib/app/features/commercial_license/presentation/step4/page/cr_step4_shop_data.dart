import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/commercial_license/presentation/step4/bloc/cr_step4_shop_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/presentation/widgets/check_boxes/text_field_with_check_btn.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/radio_buttons/vertical_radio_group_component.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../vd/presentation/widgets/details_widgets/incident_desc_widgets/vd_create_incident_addetional_fields.dart';
import '../../../commercial_license_exports.dart';
import '../../step3/bloc/map_bloc.dart';
import '../widgets/clean_contract_card.dart';

class CRStep4ShopData extends StatefulWidget {
  const CRStep4ShopData({Key? key}) : super(key: key);

  @override
  State<CRStep4ShopData> createState() => _CRStep4ShopDataState();
}

class _CRStep4ShopDataState extends State<CRStep4ShopData> {
  TextEditingController _deedServiceController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<CrStep4ShopDataCubit>().initForm();
    context.read<CrStep4ShopDataCubit>().salamaBillFawery();
    context.read<CrStep4ShopDataCubit>().salamaReportFawery();
    context.read<CrStep4ShopDataCubit>().getDeedOwnerShipsTypes();
    context.read<CrStep4ShopDataCubit>().getCleanOptions();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CrStep4ShopDataCubit, CrStep4ShopDataState>(
        listener: (context, state) {
      if (state.status == BlocStatus.failure ||
          state.deedOptionsStatus == BlocStatus.failure ||
          state.cleanOptionsStatus == BlocStatus.failure ||
          state.contractsListStatus == BlocStatus.failure ||
          state.investmentListStatus == BlocStatus.failure) {
        CommonFunctions.showError(state.errorMessage ?? "");
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
                        const CRHeaderDesc(header: "بيانات المحل واللوحات"),
                        const SizedBox(height: 16),
                        YesNoRadioGroupWidget(
                          groupName: 'هل يوجد لديك علامة تجارية ؟',
                          currentValue: state.brand,
                          onChanged: (value) {
                            context
                                .read<CrStep4ShopDataCubit>()
                                .updateFields(brand: value);
                          },
                        ),
                        CustomTextFieldWidget(
                          label: "اسم المحل",
                          hintText: "ادخل اسم المحل",
                          bottomMargin: 24,
                          initialValue: state.shopName,
                          onChanged: (value) {
                            context
                                .read<CrStep4ShopDataCubit>()
                                .updateFields(shopName: value);
                          },
                        ),
                        CustomTextFieldWidget(
                          label: "رقم المحل",
                          hintText: "ادخل رقم المحل",
                          isDigitsOnly: true,
                          keyboardType: TextInputType.number,
                          bottomMargin: 24,
                          onChanged: (value) {
                            context
                                .read<CrStep4ShopDataCubit>()
                                .updateFields(shopUnitNumber: value);
                          },
                        ),
                        CustomTextFieldWidget(
                          label: "رقم العقار",
                          hintText: "ادخل رقم العقار",
                          isDigitsOnly: true,
                          keyboardType: TextInputType.number,
                          bottomMargin: 24,
                          initialValue: state.blockNumber,
                          onChanged: (value) {
                            context
                                .read<CrStep4ShopDataCubit>()
                                .updateFields(blockNumber: value);
                          },
                        ),
                        CustomTextFieldWidget(
                          label: "عدد الفتحات",
                          hintText: "ادخل عدد الفتحات",
                          isDigitsOnly: true,
                          keyboardType: TextInputType.number,
                          bottomMargin: 24,
                          initialValue: state.holesCount.toString(),
                          onChanged: (value) {
                            context
                                .read<CrStep4ShopDataCubit>()
                                .updateFields(holesCount: int.tryParse(value));
                          },
                        ),
                        CustomTextFieldWidget(
                          label: "عدد الادوار في المحل",
                          hintText: "ادخل عدد الادوار في المحل",
                          isDigitsOnly: true,
                          keyboardType: TextInputType.number,
                          bottomMargin: 24,
                          initialValue: state.floorCount.toString(),
                          onChanged: (value) {
                            context
                                .read<CrStep4ShopDataCubit>()
                                .updateFields(floorCount: int.tryParse(value));
                          },
                        ),
                        CustomTextFieldWidget(
                          label: "عدد الكاميرات في المحل",
                          hintText: "ادخل عدد الكاميرات في المحل",
                          isDigitsOnly: true,
                          keyboardType: TextInputType.number,
                          initialValue: state.noOfCameras.toString(),
                          bottomMargin: 24,
                          onChanged: (value) {
                            context
                                .read<CrStep4ShopDataCubit>()
                                .updateFields(noOfCameras: int.tryParse(value));
                          },
                        ),
                        if (context
                            .read<CrStep4ShopDataCubit>()
                            .cameraEndorsmentText
                            .isNotEmpty)
                          UndertakingWidget(
                            text: "أتعهد على جميع ماتم ذكره اعلاه",
                            desc: context
                                    .read<CrStep4ShopDataCubit>()
                                    .saveLocationResponse!
                                    .endorsementText ??
                                "",
                            onChange: (value) {},
                            initialValue: false,
                          ),
                        YesNoRadioGroupWidget(
                          groupName: 'هل يوجد مصعد في المحل ؟',
                          currentValue: state.hasElevator,
                          onChanged: (value) {
                            context
                                .read<CrStep4ShopDataCubit>()
                                .updateFields(hasElevator: value);
                          },
                        ),
                        YesNoRadioGroupWidget(
                          groupName: 'هل يقع المحل في مركز تجاري ؟',
                          currentValue: state.existInMall,
                          onChanged: (value) {
                            context
                                .read<CrStep4ShopDataCubit>()
                                .updateFields(existInMall: value);
                          },
                        ),
                        if (state.existInMall == true) ...[
                          CustomTapWidgetForLongDialog(
                            items: const [],
                            value: null,
                            label: "المركز التجاري",
                            marginBottom: 24,
                            onChangeType: (item) {},
                          ),
                          CustomTextFieldWidget(
                            label: "الطابق",
                            hintText: "ادخل الطابق",
                            isDigitsOnly: true,
                            keyboardType: TextInputType.number,
                            bottomMargin: 24,
                            initialValue: state.floorNumber?.toString() ?? "",
                            onChanged: (value) {
                              context.read<CrStep4ShopDataCubit>().updateFields(
                                  floorNumber: int.tryParse(value));
                            },
                          ),
                        ],
                        YesNoRadioGroupWidget(
                          groupName: 'هل انت متعاقد مع احدى شركات النظافة ؟',
                          currentValue: state.isCitizenPledgedToClean,
                          onChanged: (value) {
                            if (value != null) {
                              context
                                  .read<CrStep4ShopDataCubit>()
                                  .updateIsCitizenPledgedToClean(value);
                            }
                          },
                        ),
                        if (state.isCitizenPledgedToClean == true &&
                            state.cleanContractshowAttach() &&
                            !state.cleanOptionCLEANCONTRACT() &&
                            !state.cleanContractshowPayAll())
                          HijriCalendarAddetionalField(
                            fieldName: 'تاريخ انتهاء عقد النظافة',
                            isMandatory: true,
                            onChanged: (value) {
                              context
                                  .read<CrStep4ShopDataCubit>()
                                  .updateCleanContractDate(value ?? "");
                            },
                          ),
                        if (state.isCitizenPledgedToClean == true &&
                            (state.cleanContractshowService() ||
                                state.cleanOptionCLEANCONTRACT() ||
                                state.cleanOptionOPTIONAL()) &&
                            state.contractsListStatus ==
                                BlocStatus.success) ...[
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  state.cleanContractsResponse?.items?.length ??
                                      0,
                              itemBuilder: (ctx, index) {
                                return CleanContractCard(
                                    item: state
                                        .cleanContractsResponse!.items![index],
                                    onSelect: (CleanContractItem? item) {
                                      context
                                          .read<CrStep4ShopDataCubit>()
                                          .selectCleanContract(item);
                                    },
                                    selected: state.selectedCleanContract);
                              }),
                        ],
                        if (context
                                .read<CrStep4ShopDataCubit>()
                                .saveLocationResponse
                                ?.showSalamaPermit ==
                            true) ...[
                          YesNoRadioGroupWidget(
                            groupName: 'هل لديك تصريح سلامة ؟',
                            currentValue: state.salamaPermitExist,
                            onChanged: (value) {
                              context
                                  .read<CrStep4ShopDataCubit>()
                                  .updateSalamaPermitExists(
                                      salamaPermitExist: value);
                            },
                          ),
                          if (state.isFawryReport == true &&
                              state.salamaPermitExist == false)
                            CustomTextFieldWidget(
                              label: "رقم التقرير الفني",
                              hintText: "رقم التقرير الفني",
                              isDigitsOnly: true,
                              keyboardType: TextInputType.number,
                              bottomMargin: 24,
                              initialValue: state.slamaReportNumber.toString(),
                              onChanged: (value) {
                                context
                                    .read<CrStep4ShopDataCubit>()
                                    .updateSalamaPermitReport(
                                        salamaReportNumber: value);
                              },
                            ),
                          if (state.isFawryBill == true &&
                              state.salamaPermitExist == false)
                            CustomTextFieldWidget(
                              label: "رقم الفاتورة الفني",
                              hintText: "رقم الفاتورة الفني",
                              isDigitsOnly: true,
                              keyboardType: TextInputType.number,
                              bottomMargin: 24,
                              initialValue: state.slamaBillNumber.toString(),
                              onChanged: (value) {
                                context
                                    .read<CrStep4ShopDataCubit>()
                                    .updateSalamaPermitBill(
                                        salamaBillNumber: value);
                              },
                            ),
                          if (state.salamaPermitExist == true)
                            CustomTextFieldWidget(
                              label: "رقم تصريح سلامة",
                              hintText: "رقم تصريح سلامة",
                              isDigitsOnly: true,
                              keyboardType: TextInputType.number,
                              bottomMargin: 24,
                              initialValue: state.salamaPermitNumber.toString(),
                              onChanged: (value) {
                                context
                                    .read<CrStep4ShopDataCubit>()
                                    .updateSalamaPermitNumber(
                                        salamaPermitNumber: value);
                              },
                            ),
                        ],
                        HorizontalRadioGroup<CRSubmitterType>(
                          groupName: 'صفة المقدم بالنسبة لموقع المحل',
                          currentItem: state.crSubmitterType,
                          items: [
                            RadioItem<CRSubmitterType>(
                                radioValue: CRSubmitterType.owner,
                                radioText: "مالك"),
                            RadioItem<CRSubmitterType>(
                                radioValue: CRSubmitterType.rental,
                                radioText: "مستأجر"),
                          ],
                          onChanged: (value) {
                            context
                                .read<CrStep4ShopDataCubit>()
                                .updateSubmitterType(value!);
                          },
                        ),
                        if (state.crSubmitterType == CRSubmitterType.owner)
                          HorizontalRadioGroup(
                            groupName: 'نوع العقد',
                            currentItem: state.crContractType,
                            items: [
                              RadioItem<CRContractType>(
                                  radioText: "عقد تملك المبنى (صك)",
                                  radioValue: CRContractType.deed),
                            ],
                            onChanged: (value) {
                              context
                                  .read<CrStep4ShopDataCubit>()
                                  .updateCRContractType(value!);
                            },
                          ),
                        if (state.crContractType == CRContractType.deed &&
                            state.crSubmitterType == CRSubmitterType.owner)
                          HorizontalRadioGroup<CRContractOption>(
                            groupName: 'طريقة ادخال العقد',
                            currentItem: state.crContractOption,
                            items: [
                              if (state.showAttachDeed())
                                RadioItem<CRContractOption>(
                                    radioText: "ارفاق ملف",
                                    radioValue: CRContractOption.attach),
                              if (state.showServicehDeed())
                                RadioItem<CRContractOption>(
                                    radioText: "رقم عقد الصك الالكتروني",
                                    radioValue: CRContractOption.service),
                            ],
                            onChanged: (value) {
                              context
                                  .read<CrStep4ShopDataCubit>()
                                  .updateCRContractOption(value!);
                            },
                          ),
                        if (state.crContractType == CRContractType.deed &&
                            state.crSubmitterType == CRSubmitterType.owner &&
                            state.crContractOption ==
                                CRContractOption.attach) ...[
                          CustomTextFieldWidget(
                            label: "رقم عقد التملك (الصك)",
                            hintText: "رقم عقد التملك (الصك)",
                            isDigitsOnly: true,
                            keyboardType: TextInputType.number,
                            bottomMargin: 24,
                            initialValue: state.contractNumber,
                            onChanged: (value) {
                              context
                                  .read<CrStep4ShopDataCubit>()
                                  .updateContractNumber(value);
                            },
                          ),
                          HijriCalendarAddetionalField(
                            fieldName: 'تاريخ عقد التملك',
                            isMandatory: true,
                            onChanged: (value) {
                              context
                                  .read<CrStep4ShopDataCubit>()
                                  .updateContractDate(value ?? "");
                            },
                          ),
                        ],
                        if (state.crContractType == CRContractType.deed &&
                            state.crSubmitterType == CRSubmitterType.owner &&
                            state.crContractOption ==
                                CRContractOption.service) ...[
                          VerticalRadioGroup<String>(
                            groupName: '',
                            currentItem: state.deedOption,
                            items: (state.deedOptions ?? []).map((e) {
                              return RadioItem<String>(
                                  radioText: e.tr(), radioValue: e);
                            }).toList(),
                            onChanged: (value) {
                              context
                                  .read<CrStep4ShopDataCubit>()
                                  .updateDeedInfo(ownershipType: value);
                            },
                          ),
                          TextWithCheckBtn(
                            title: "رقم عقد التملك (الصك)",
                            hint: "رقم عقد التملك (الصك)",
                            validate: (String? t) {},
                            controller: _deedServiceController,
                            isValidate: state.deedVerified ?? false,
                            currentValue: state.contractNumber,
                            verify: () {
                              context
                                  .read<CrStep4ShopDataCubit>()
                                  .getDeedInfoHandler();
                            },
                            onTextChanged: (value) {
                              context
                                  .read<CrStep4ShopDataCubit>()
                                  .updateDeedInfo(deedNumber: value);
                            },
                          ),
                        ],
                        if (state.crSubmitterType == CRSubmitterType.rental)
                          HorizontalRadioGroup(
                            groupName: 'نوع العقد',
                            currentItem: state.crContractType,
                            items: [
                              RadioItem<CRContractType>(
                                  radioText: "عقد الإيجار",
                                  radioValue: CRContractType.ejar),
                              RadioItem<CRContractType>(
                                  radioText: "عقد استثمار",
                                  radioValue: CRContractType.invest),
                            ],
                            onChanged: (value) {
                              context
                                  .read<CrStep4ShopDataCubit>()
                                  .updateCRContractType(value!);
                            },
                          ),
                        if (state.crContractType == CRContractType.ejar &&
                            state.crSubmitterType == CRSubmitterType.rental)
                          HorizontalRadioGroup<CRContractOption>(
                            groupName: 'طريقة ادخال العقد',
                            currentItem: state.crContractOption,
                            items: [
                              if (state.showAttachEjar())
                                RadioItem<CRContractOption>(
                                    radioText: "إرفاق عقد الإيجار",
                                    radioValue: CRContractOption.attach),
                              if (state.showServiceEjar())
                                RadioItem<CRContractOption>(
                                    radioText:
                                        "استخدام رقم عقد الإيجار الالكتروني",
                                    radioValue: CRContractOption.service),
                            ],
                            onChanged: (value) {
                              context
                                  .read<CrStep4ShopDataCubit>()
                                  .updateCRContractOption(value!);
                            },
                          ),
                        if (state.crContractType == CRContractType.ejar &&
                            state.crSubmitterType == CRSubmitterType.rental &&
                            state.crContractOption ==
                                CRContractOption.attach) ...[
                          CustomTextFieldWidget(
                            label: "رقم عقد الايجار",
                            hintText: "رقم عقد الايجار",
                            isDigitsOnly: true,
                            keyboardType: TextInputType.number,
                            bottomMargin: 24,
                            initialValue: state.contractNumber,
                            onChanged: (value) {
                              context
                                  .read<CrStep4ShopDataCubit>()
                                  .updateContractNumber(value);
                            },
                          ),
                          HijriCalendarAddetionalField(
                            fieldName: "تاريخ انتهاء عقد الايجار",
                            isMandatory: true,
                            onChanged: (value) {
                              context
                                  .read<CrStep4ShopDataCubit>()
                                  .updateContractDate(value ?? "");
                            },
                          ),
                        ],
                        if (state.crContractType == CRContractType.ejar &&
                            state.crSubmitterType == CRSubmitterType.rental &&
                            state.crContractOption ==
                                CRContractOption.service &&
                            state.showServiceEjar()) ...[
                          CustomTextFieldWidget(
                            label: "رقم العقد",
                            hintText: "رقم العقد",
                            isDigitsOnly: true,
                            keyboardType: TextInputType.number,
                            bottomMargin: 24,
                            initialValue: "",
                            onChanged: (value) {
                              context
                                  .read<CrStep4ShopDataCubit>()
                                  .updateTenancyInfo(
                                      tenancyContractNumber: value);
                            },
                          ),
                          CustomTextFieldWidget(
                            label: "رقم النسخة",
                            hintText: "رقم النسخة",
                            isDigitsOnly: true,
                            keyboardType: TextInputType.number,
                            bottomMargin: 24,
                            initialValue: "",
                            onChanged: (value) {
                              context
                                  .read<CrStep4ShopDataCubit>()
                                  .updateTenancyInfo(versionNumber: value);
                            },
                          ),
                          CustomTextFieldWidget(
                            label: "رقم هوية ممثل المستأجر",
                            hintText: "رقم هوية ممثل المستأجر",
                            isDigitsOnly: true,
                            keyboardType: TextInputType.number,
                            bottomMargin: 24,
                            initialValue: "",
                            onChanged: (value) {
                              context
                                  .read<CrStep4ShopDataCubit>()
                                  .updateTenancyInfo(id: value);
                            },
                          ),
                          ElevatedButtonWidget.verify(
                              text: (state.ejarVerified ?? false)
                                  ? "done_check".tr()
                                  : "verify".tr(),
                              onPressed: () {
                                context
                                    .read<CrStep4ShopDataCubit>()
                                    .getEjarInfoHandler();
                              }),
                          const CustomVerticalSpace(
                            height: 16,
                          )
                        ],
                        if (state.crContractType == CRContractType.invest &&
                            state.crSubmitterType == CRSubmitterType.rental)
                          HorizontalRadioGroup<CRContractOption>(
                            groupName: 'طريقة ادخال العقد',
                            currentItem: state.crContractOption,
                            items: [
                              if (state.showAttachInvest())
                                RadioItem<CRContractOption>(
                                    radioText: "إرفاق عقد الاستثمار",
                                    radioValue: CRContractOption.attach),
                              if (state.showServiceInvest())
                                RadioItem<CRContractOption>(
                                    radioText:
                                        "استخدام رقم عقد الاستثمار الالكتروني",
                                    radioValue: CRContractOption.service),
                            ],
                            onChanged: (value) {
                              context
                                  .read<CrStep4ShopDataCubit>()
                                  .updateCRContractOption(value!);
                            },
                          ),
                        if (state.crContractType == CRContractType.invest &&
                            state.crSubmitterType == CRSubmitterType.rental &&
                            state.crContractOption ==
                                CRContractOption.service &&
                            state.investmentListStatus.isSubmissionSuccess) ...[
                          MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.investmentContractResponse
                                        ?.items?.length ??
                                    0,
                                itemBuilder: (ctx, index) {
                                  return InvestMentContractCard(
                                      item: state.investmentContractResponse!
                                          .items![index],
                                      onSelect: (InvestmentContractItem? item) {
                                        context
                                            .read<CrStep4ShopDataCubit>()
                                            .selectInvestmentContract(item);
                                      },
                                      selected:
                                          state.selectedInvestmentContract);
                                }),
                          ),
                        ],
                        HorizontalRadioGroup(
                          groupName: 'اللوحات',
                          currentItem: null,
                          items: [
                            //    RadioItem(radioValue: "اضافه عقد لوحه", id: 1),
                            //    RadioItem(radioValue: "اضافه بيانات اللوحه", id: 1),
                          ],
                          onChanged: (value) {},
                        ),
                        const BillboardComponent(),
                        /*  const NotesWidget(
                          notes: [
                            "عزيزي المستفيد, يمكنك الاطلاع على إرشادات اللوحات"
                          ],
                        ),*/
                      ],
                    ),
                  ),
                ),
              ),
              CRPreviousNextButtons(
                isBtnDisabled: false,
                onPressed: () {
                  context.read<CrStep4ShopDataCubit>().save();
                },
              ),
            ],
          ),
          if (state.status.isSubmissionLoading ||
              state.deedOptionsStatus == BlocStatus.loading ||
              state.cleanOptionsStatus == BlocStatus.loading ||
              state.contractsListStatus == BlocStatus.loading ||
              state.investmentListStatus == BlocStatus.loading)
            const CustomCircularLoadingWidget(),
        ],
      );
    });
  }
}
