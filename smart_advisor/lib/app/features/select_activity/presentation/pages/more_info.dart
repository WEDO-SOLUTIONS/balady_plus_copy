import 'package:smart_advisor/app/features/select_activity/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';

import '../../../manage_license_flow/domain/entities/delegator_entity.dart';
import '../../../select_activity/domain/entities/addetional_activites_response.dart';
import '../../../shared_features/new_app_bar.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
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

class MoreInfoPage extends StatefulWidget {
  MoreInfoPage({
    super.key,
  });

  @override
  State<MoreInfoPage> createState() => _MoreInfoPageState();
}

class _MoreInfoPageState extends State<MoreInfoPage> {
  var accomodationTypes = [
    LookUpItem(id: 1, name: "الفئة الأولى"),
    LookUpItem(id: 2, name: "الفئة الثانية"),
    LookUpItem(id: 3, name: "الفئة الثالثة"),
    LookUpItem(id: 4, name: "الفئة الرابعة"),
    LookUpItem(id: 5, name: "الفئة الخامسة")
  ];

  var workerTypes = [
    LookUpItem(id: 1, name: "رجال"),
    LookUpItem(id: 2, name: "نساء"),
    LookUpItem(id: 3, name: "رجال ونساء"),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainFlowBloc, MainFlowState>(
      listener: (context, state) {
        if (state.status == BlocStatus.failure)
          CommonFunctions.showError(state.errorMessage ?? "");
      },
      child: BlocBuilder<MainFlowBloc, MainFlowState>(
        builder: (context, state) {
          List<AddetionalActivityItem>? addetionalActivitesResponse = state
              .addetionalActivitesResponse
              ?.where((e) => e.isSelected == true)
              .toList();

          List<LookUpItem> delegators = state.delegators
                  ?.map((e) => LookUpItem(
                      id: int.tryParse(e.crNumber ?? "") ?? 0,
                      name: e.entityName ?? ""))
                  .toList() ??
              [];
          return Stack(
            children: [
              Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFCCC9DC)
                            .withOpacity(0.24), // Color with 24% opacity
                        offset: const Offset(0, 6), // X: 0, Y: 6
                        blurRadius: 20, // Blur radius of 20
                        spreadRadius: 0, // Spread of 0
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFF8FFEC).withOpacity(
                                      0.73), // Lightest color with opacity
                                  const Color(0xFFEBE9FF).withOpacity(
                                      0.52), // Mid color with opacity
                                  const Color(0xFFEAF6D8).withOpacity(0.73),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: const [
                                  0.0,
                                  0.5,
                                  1.0
                                ], // Adjust the stop points for smooth gradient transition
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                          ),
                          NewAppBar(title: "انشاء الطلب"),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                sectionTitle('أدخل البيانات الآتيه'),
                                const SizedBox(
                                  height: 0,
                                ),
                                Column(
                                  children: [
                                    CalculatorDropdown(
                                      title: "السجل التجاري",
                                      list: delegators,
                                      onSelect: (LookUpItem item) {
                                        DelegatorEntity? d = state.delegators
                                            ?.firstWhere((e) =>
                                                e.crNumber ==
                                                item.id.toString());
                                        if (d != null)
                                          context.read<MainFlowBloc>().add(
                                              SelectDelegatorEvent(
                                                  delegator: d));
                                      },
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    CalculatorCustomTextField(
                                      title: "المساحة الكلية للمنشأة / المحل",
                                      suffix: 'متر مربع',
                                      value: state.shopArea != null
                                          ? state.shopArea.toString()
                                          : null,
                                      onChanged: (String text) {
                                        context.read<MainFlowBloc>().add(
                                            ChangeShopAreaValueEvent(
                                                data: text));
                                      },
                                    ),
                                    if (state.details?.isHotel == true) ...[
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      CalculatorDropdown(
                                        title: "الفئة",
                                        list: accomodationTypes,
                                        onSelect: (LookUpItem item) {
                                          context.read<MainFlowBloc>().add(
                                              ChangeAccomodationTypeEvent(
                                                  item: item));
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      CalculatorCustomTextField(
                                        title: "عدد الوحدات",
                                        suffix: 'وحدة',
                                        onChanged: (String text) {
                                          context.read<MainFlowBloc>().add(
                                              ChangeUnitCountEvent(data: text));
                                        },
                                      ),
                                    ],
                                    const SizedBox(height: 16),
                                    CustomTextDisplay(
                                      title: 'مساحة النشاط الرئيسي',
                                      value: state.getTotalArea().toString(),
                                      unit: 'متر مربع',
                                    ),
                                  ],
                                ),
                                if (addetionalActivitesResponse?.isNotEmpty ??
                                    false)
                                  const SizedBox(height: 16),
                                if (addetionalActivitesResponse?.isNotEmpty ??
                                    false)
                                  sectionTitle('الأنشطة الإضافية'),
                                if (addetionalActivitesResponse?.isNotEmpty ??
                                    false)
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppColor.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12)),
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          addetionalActivitesResponse?.length ??
                                              0,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (ctx, index) {
                                        return AddetionalActivityItemWidget(
                                          onDelete: null,
                                          label: addetionalActivitesResponse?[
                                                      index]
                                                  .activityName ??
                                              "",
                                          onChanged: (String? t) {
                                            context.read<MainFlowBloc>().add(
                                                ChangeAddetionalActivityEvent(
                                                    area: t ?? "",
                                                    index:
                                                        addetionalActivitesResponse?[
                                                                    index]
                                                                .activityId ??
                                                            0));
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                SizedBox(height: 16),
                                const SizedBox(height: 16),
                                CalculatorDropdown(
                                  title: "نوع العاملين",
                                  list: workerTypes,
                                  onSelect: (LookUpItem item) {
                                    context
                                        .read<MainFlowBloc>()
                                        .add(ChangeWorkerTypeEvent(item: item));
                                  },
                                ),
                                const SizedBox(height: 16),
                                CustomButton(
                                    onPress: () {
                                      if (((state.addetionalActivitesResponse
                                                      ?.where((e) =>
                                                          e.isSelected == true)
                                                      .toList() ??
                                                  [])
                                              .any((e) => e.area == null)) ==
                                          true) {
                                        CommonFunctions.showError(
                                            "الرجاء إدخال مساحات الأنشطة الإضافية");
                                      } else if ((state.details?.isHotel ??
                                              false) &&
                                          (state.unitCount?.isEmpty ?? true)) {
                                        CommonFunctions.showError(
                                            "الرجاء إدخال عدد الوجدات");
                                      } else if ((state.details?.isHotel ??
                                              false) &&
                                          (state.acomodationType == null)) {
                                        CommonFunctions.showError(
                                            "الرجاء إدخال الفئة");
                                      } else if (state.getTotalArea() < 0) {
                                        CommonFunctions.showError(
                                            "مساحة المحل أقل من مجموع مساحات الأنشطة الإضافية");
                                      } else if (state.getTotalArea() == 0) {
                                        CommonFunctions.showError(
                                            "مساحة النشاط الرئيسي يجب أن تكون أكبر من الصفر");
                                      } else if (state.workerType == null) {
                                        CommonFunctions.showError(
                                            "يجب إختيار نوع العاملين");
                                      } else {
                                        context
                                            .read<MainFlowBloc>()
                                            .openAddetioanlData();
                                      }
                                    },
                                    text: 'بدء الطلب'),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              if (state.status == BlocStatus.loading)
                Center(
                  child: CircularProgressIndicator(
                    color: AppColor.statusAccentColor,
                  ),
                )
            ],
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

class AddetionalActivityItemWidget extends StatelessWidget {
  final String label;
  final Function(String? t) onChanged;
  final Function? onDelete;

  const AddetionalActivityItemWidget(
      {super.key, required this.label, required this.onChanged, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xD5DAE3).withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(label,
                        style: AppStyle.calloutBoldStyle
                            .copyWith(color: AppColor.textPrimaryColor)),
                  ),
                  if (onDelete != null)
                    InkWell(
                        onTap: () {
                          onDelete!();
                        },
                        child:
                            const Icon(Icons.close, color: Color(0xA31E2A36))),
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xD5DAE3).withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
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
  final Function onDelete;
  const PlateInfoWidget(
      {super.key, required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.name, style: TextStyle(fontSize: 16)),
              InkWell(
                onTap: () => onDelete(),
                child: Icon(
                  Icons.close,
                  color: AppColor.primary,
                ),
              )
            ],
          ),
          Text(item.area ?? "", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
