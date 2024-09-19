import '/app/core/utils/utils_exports.dart';
import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/fees_calculator/presentation/bloc/calculator_bloc.dart';
import '/app/features/fees_calculator/presentation/widgets/board_dialog.dart';
import '/app/features/fees_calculator/presentation/widgets/calculator_drop_down.dart';
import '/app/features/fees_calculator/presentation/widgets/calculator_text_field.dart';
import '/app/features/fees_calculator/presentation/widgets/custom_text_view.dart';
import '/app/features/select_activity/domain/entities/activity_details_page_params.dart';
import '/app/features/shared_features/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import '/app/features/fees_calculator/presentation/pages/result_page.dart';

import '/app/features/shared_features/widgets/app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeesCalculatorPage extends StatefulWidget {
  final ActivityDetailsPageParams args;
  const FeesCalculatorPage({super.key, required this.args});

  @override
  State<FeesCalculatorPage> createState() => _FeesCalculatorPageState();
}

class _FeesCalculatorPageState extends State<FeesCalculatorPage> {
  List<LookUpItem> licenseYears = [];

  var cleanOptions = [
    LookUpItem(id: 1, name: "رسوم بلدية", idStr: "MUNUCIPALITY_FEES"),
    LookUpItem(id: 2, name: "إرفاق", idStr: "CONTRACT_ATTACH"),
    LookUpItem(id: 3, name: "عقد إلكتروني", idStr: "CONTRACT_SERVICE")
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0;
        i < (widget.args.entityActivityDetailsResponse?.maxYears ?? 0);
        i++) {
      licenseYears.add(LookUpItem(id: i + 1, name: (i + 1).toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalculatorBloc(args: widget.args),
      child: BlocBuilder<CalculatorBloc, CalculatorState>(
        builder: (context, state) {
          return Scaffold(
            appBar: const CustomAppBar(
              title: "حاسبة الرسوم",
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionTitle('أدخل البيانات الآتيه'),
                    const SizedBox(height: 16),
                    CalculatorDropdown(
                      title: "عدد سنوات الترخيص",
                      list: licenseYears,
                      onSelect: (LookUpItem item) {
                        context
                            .read<CalculatorBloc>()
                            .add(ChangeLicenseYears(item: item));
                      },
                    ),
                    const SizedBox(height: 16),
                    /*CalculatorCustomTextField(
                      title: 'المساحه المتوقعه للنشاط الرئيسي للمحل',
                      suffix: 'متر مربع',
                      onChanged: (String text) {


                      },
                    ),
                    const SizedBox(height: 16),*/
                    CustomTextDisplay(
                      title: 'المساحه الكليه للمنشاه',
                      value: state.getTotalArea().toString(),
                      unit: 'متر مربع',
                    ),
                    if (state.addetionalActivitesResponse?.isNotEmpty ?? false)
                      const SizedBox(height: 16),
                    if (state.addetionalActivitesResponse?.isNotEmpty ?? false)
                      sectionTitle('الأنشطة الإضافية'),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.addetionalActivitesResponse?.length ?? 0,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return AddetionalActivityItem(
                          onDelete: () {
                            context.read<CalculatorBloc>().add(
                                DeleteAddetionalActivityItemEvent(
                                    index: index));
                          },
                          label: state.addetionalActivitesResponse?[index]
                                  .activityName ??
                              "",
                          onChanged: (String? t) {
                            context.read<CalculatorBloc>().add(
                                ChangeAddetionalActivityEvent(
                                    area: t ?? "", index: index));
                          },
                        );
                      },
                    ),
                    if (state.permits?.isNotEmpty ?? false)
                      const SizedBox(height: 16),
                    if (state.permits?.isNotEmpty ?? false)
                      sectionTitle('التصاريح'),
                    if (state.permits?.isNotEmpty ?? false)
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.permits?.length ?? 0,
                        itemBuilder: (ctx, index) {
                          return PermitItem(
                            permitType: state.permits![index].permitTypeId!,
                            onDelete: () {
                              context.read<CalculatorBloc>().add(
                                  DeleteAddetionalActivityItemEvent(
                                      index: index));
                            },
                            label: state.permits?[index].name ?? "",
                            onDaysChanged: (String? t) {
                              context.read<CalculatorBloc>().add(
                                  ChangePermitDaysEvent(
                                      data: t ?? "", index: index));
                            },
                            onHeightChanged: (String? data) {
                              context.read<CalculatorBloc>().add(
                                  ChangePermitHeightEvent(
                                      data: data ?? "", index: index));
                            },
                            onNoOfVeichleChanged: (String? data) {
                              context.read<CalculatorBloc>().add(
                                  ChangePermitNoOfVeichlesEvent(
                                      data: data ?? "", index: index));
                            },
                            onWidthChanged: (String? data) {
                              context.read<CalculatorBloc>().add(
                                  ChangePermitWidthEvent(
                                      data: data ?? "", index: index));
                            },
                          );
                        },
                      ),
                    // SizedBox(height: 16),
                    sectionTitle('خيارات النظافه'),
                    CalculatorDropdown(
                      title: "خيارات النظافة",
                      list: cleanOptions,
                      onSelect: (LookUpItem item) {
                        context
                            .read<CalculatorBloc>()
                            .add(ChangeCleanOptionEvent(item: item));
                      },
                    ),
                    const SizedBox(height: 16),
                    sectionTitle('معلومات اللوحات'),
                    CustomButton(
                        onPress: () {
                          showModalBottomSheet(
                            backgroundColor: const Color(0xff000000),
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext c) =>
                                BoardDialog(onAdd: (item) {
                              print(item.$1);
                              context.read<CalculatorBloc>().add(
                                  AddBoardnEvent(item: item.$1, area: item.$2));
                            }),
                          );
                        },
                        text: "إضافة لوحة"),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.boards?.length ?? 0,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return PlateInfoWidget(
                          item: state.boards![index],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                        onPress: () {
                          context.read<CalculatorBloc>().add(CalculateEvent());

                          /* Navigator.push(context,
                              MaterialPageRoute(builder: (ctx) {
                            return const ResultPage();
                          }));*/
                        },
                        text: 'احسب'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class AddetionalActivityItem extends StatelessWidget {
  final String label;
  final Function(String? t) onChanged;
  final Function onDelete;

  const AddetionalActivityItem(
      {super.key,
      required this.label,
      required this.onChanged,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColor.surfaceSecondaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label,
                      style: AppStyle.calloutBoldStyle
                          .copyWith(color: AppColor.textPrimaryColor)),
                  InkWell(
                      onTap: () {
                        onDelete();
                      },
                      child: const Icon(Icons.close, color: Color(0xA31E2A36))),
                ],
              ),
              const SizedBox(height: 8),
              CalculatorCustomTextField(
                title: 'المساحة',
                suffix: "متر مربع",
                onChanged: (String y) {
                  onChanged(y);
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}

class PermitItem extends StatelessWidget {
  final String label;
  final int permitType;
  final Function(String? t) onNoOfVeichleChanged;
  final Function(String? t) onWidthChanged;
  final Function(String? t) onHeightChanged;
  final Function(String? t) onDaysChanged;
  final Function onDelete;

  const PermitItem({
    super.key,
    required this.label,
    required this.permitType,
    required this.onDelete,
    required this.onNoOfVeichleChanged,
    required this.onWidthChanged,
    required this.onDaysChanged,
    required this.onHeightChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColor.surfaceSecondaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label,
                      style: AppStyle.calloutBoldStyle
                          .copyWith(color: AppColor.textPrimaryColor)),
                  InkWell(
                      onTap: () {
                        onDelete();
                      },
                      child: const Icon(Icons.close, color: Color(0xA31E2A36))),
                ],
              ),
              const SizedBox(height: 8),
              if (permitType == 1013) ...[
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CalculatorCustomTextField(
                            title: 'الطول',
                            suffix: "متر",
                            onChanged: (String y) {
                              onHeightChanged(y);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 32,
                        ),
                        Expanded(
                          child: CalculatorCustomTextField(
                            title: 'العرض',
                            suffix: "متر",
                            onChanged: (String y) {
                              onWidthChanged(y);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    CalculatorCustomTextField(
                      title: 'عدد الأيام',
                      suffix: "يوم",
                      onChanged: (String y) {
                        onDaysChanged(y);
                      },
                    ),
                  ],
                ),
                if (permitType == 1037) ...[
                  Row(
                    children: [
                      Expanded(
                        child: CalculatorCustomTextField(
                          title: 'عدد العربات',
                          suffix: "عربة",
                          onChanged: (String y) {
                            onNoOfVeichleChanged(y);
                          },
                        ),
                      ),
                    ],
                  )
                ],
                const SizedBox(
                  height: 16,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}

class PlateInfoWidget extends StatelessWidget {
  final LookUpItem item;
  const PlateInfoWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.surfaceSecondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item.name, style: TextStyle(fontSize: 16)),
          Text(item.area ?? "", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
