import 'package:balady_plus/app/features/commercial_license/presentation/step4/bloc/cr_step4_shop_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../vd/presentation/widgets/details_widgets/incident_desc_widgets/vd_create_incident_addetional_fields.dart';
import '../../../commercial_license_exports.dart';
import '../../step3/bloc/map_bloc.dart';

class CRStep4ShopData extends StatefulWidget {
  const CRStep4ShopData({Key? key}) : super(key: key);

  @override
  State<CRStep4ShopData> createState() => _CRStep4ShopDataState();
}

class _CRStep4ShopDataState extends State<CRStep4ShopData> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<CrStep4ShopDataCubit>().initForm();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrStep4ShopDataCubit, CrStep4ShopDataState>(
        builder: (context, state) {
      return Column(
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
                            .updateFields(shopName: value);
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
                    UndertakingWidget(
                      text: "أتعهد على جميع ماتم ذكره اعلاه",
                      desc:
                          "اتعهد انا (احمد بن خالد) بالإقرار على تركيب كاميرات مراقبة   وفقا لاشتراطات الجهة المعنية",
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
                        initialValue: state.floorNumber.toString(),
                        onChanged: (value) {
                          context
                              .read<CrStep4ShopDataCubit>()
                              .updateFields(floorNumber: int.tryParse(value));
                        },
                      ),
                    ],
                    YesNoRadioGroupWidget(
                      groupName: 'هل انت متعاقد مع احدى شركات النظافة ؟',
                      currentValue: state.isCitizenPledgedToClean,
                      onChanged: (value) {
                        context
                            .read<CrStep4ShopDataCubit>()
                            .updateFields(isCitizenPledgedToClean: value);
                      },
                    ),
                    YesNoRadioGroupWidget(
                      groupName: 'هل لديك تصريح سلامة ؟',
                      currentValue: state.salamaPermitExist,
                      onChanged: (value) {
                        context
                            .read<CrStep4ShopDataCubit>()
                            .updateSalama(salamaPermitExist: value);
                      },
                    ),
                    if (state.salamaPermitExist == false)
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
                              .updateSalama(slamaReportNumber: value);
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
                              .updateSalama(salamaPermitNumber: value);
                        },
                      ),
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
                        currentItem: null,
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
                    if (state.crContractType == CRContractType.deed)
                      HorizontalRadioGroup(
                        groupName: 'طريقة ادخال العقد',
                        currentItem: null,
                        items: [
                          RadioItem<CRContractOption>(
                              radioText: "ارفاق ملف",
                              radioValue: CRContractOption.attach),
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
                        state.crContractOption == CRContractOption.attach) ...[
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
                        state.crContractOption == CRContractOption.service) ...[
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
                    const NotesWidget(
                      notes: [
                        "عزيزي المستفيد, يمكنك الاطلاع على إرشادات اللوحات"
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const CRPreviousNextButtons(isBtnDisabled: false),
        ],
      );
    });
  }
}
