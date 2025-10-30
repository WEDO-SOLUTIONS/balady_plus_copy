import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/core/utils/routes_type.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../core/utils/utils_exports.dart'
    show
        AppColor,
        AppStyle,
        BlocRequestStatus,
        CommonFunctions,
        DateTimeExtension,
        IconPath,
        RouteName;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show
        CardParameter,
        CustomTextWidget,
        DefaultAppBarWidget,
        DrawIconBasedTypeWidget,
        ExpandableCard,
        MessageDialog,
        ShimmerEffectWidget;
import '../../../../objectable_transactions/domain/entities/create_objection_page_params.dart';
import '../../../../objectable_transactions/domain/entities/transaction_details_params.dart';
import '../../../../objectable_transactions/domain/use_cases/get_transaction_details.dart';
import '../../../../vd/presentation/widgets/summery_widgets/field_data.dart';
import '../../invoices_exports.dart'
    show InvoiceDetailsCubit, InvoiceDetailsState;

class InvoiceDetailBody extends StatefulWidget {
  final String invoiceId;
  final String? crNumber;
  final String? crType;
  final String? xSourceApp;

  const InvoiceDetailBody({
    super.key,
    required this.invoiceId,
    required this.crNumber,
    required this.crType,
    this.xSourceApp,
  });

  @override
  State<InvoiceDetailBody> createState() => _InvoiceDetailBodyState();
}

class _InvoiceDetailBodyState extends State<InvoiceDetailBody> {
  @override
  void initState() {
    super.initState();
    context.read<InvoiceDetailsCubit>().getInvoiceDetailsById(
          widget.invoiceId,
          widget.crNumber,
          widget.crType,
          widget.xSourceApp,
        );

    CommonFunctions.sendUXCamEvent(UXCamEvents.openInvoicesDtails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: "bill_info".tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<InvoiceDetailsCubit, InvoiceDetailsState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (_, state) async {
            if (state.status == BlocRequestStatus.submissionGetFailure) {
              MessageDialog.showErrorNotification(msg: state.error);
            }
          },
          builder: (context, state) {
            if (state.status == BlocRequestStatus.submissionGetLoading) {
              return ListView.builder(
                itemCount: 3,
                itemBuilder: (_, __) => Container(
                  height: 200,
                  margin: const EdgeInsets.only(top: 16),
                  child: const ShimmerEffectWidget(),
                ),
              );
            } else if (state.invoice != null) {
              final invoice = state.invoice!;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const DrawIconBasedTypeWidget(
                          icon: IconPath.calendar,
                          iconSize: 24,
                        ),
                        const SizedBox(width: 4),
                        CustomTextWidget(
                          invoice.creationDate?.toWrittenDate() ?? "",
                          textStyle: AppStyle.dateTextStyle,
                        ),
                        const Spacer(),
                        Container(
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColor.primary50Light,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                CustomTextWidget(
                                  invoice.invoiceStatusName ?? "",
                                  textStyle: AppStyle.tagTextStyle,
                                ),
                                /*const Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColor.primary900Light,
                                ),*/
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    ExpandableCard(
                      title: 'invoice_info'.tr(),
                      icon: IconPath.vdSummuryDesc,
                      isExpandedByDefault: true,
                      children: [
                        CardParameter(
                          title: 'invoice_no'.tr(),
                          value: invoice.accountNumber ?? "",
                        ),
                        /*CardParameter(
                          title: 'invoice_amount'.tr(),
                          value: '${invoice.amount} ${"sar".tr()}',
                        ),
                        if (invoice.requestNumber != null)
                          CardParameter(
                            title: 'request_no'.tr(),
                            value: invoice.requestNumber.toString(),
                          ),*/
                        CardParameter(
                          title: 'invoice_issue_date'.tr(),
                          value: invoice.creationDate?.toyMD() ?? "",
                        ),
                        /* if (invoice.sadadDate != null)
                          CardParameter(
                            title: 'invoice_pay_date'.tr(),
                            value: invoice.sadadDate?.toyMD() ?? "",
                          ),*/
                        CardParameter(
                          title: 'invoice_end_date'.tr(),
                          value: invoice.dueDate?.toyMD() ?? "",
                        ),
                        CardParameter(
                          title: ("license_type").tr(),
                          value: invoice.invoiceTypeName ?? "",
                        ),
                      ],
                    ),
                    ExpandableCard(
                      title: "invoice_detail_title".tr(),
                      icon: IconPath.aboutBalady,
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: state.invoice?.details?.length ?? 0,
                            itemBuilder: (ctx, index) {
                              return Container(
                                margin: EdgeInsets.only(top: 16),
                                child: FieldData(
                                  title:
                                      state.invoice?.details?[index].feeName ??
                                          "",
                                  subTitle: state
                                          .invoice?.details?[index].amount
                                          .toString() ??
                                      "",
                                ),
                              );
                            }),
                        FieldData(
                          title: "invoice_bill_total".tr(),
                          subTitle: state.invoice?.amount?.toString() ?? "",
                        )
                      ],
                    ),
                    ExpandableCard(
                      title: 'violations'.tr(),
                      icon: IconPath.vdSummuryDesc,
                      children: const [InvoiceViolationsList()],
                    ),
                    ExpandableCard(
                      title: 'objections'.tr(),
                      icon: IconPath.vdSummuryDesc,
                      children: const [InvoiceObjectionsList()],
                    ),
                    if (state.invoice?.invoiceStatusId != 3)
                      ExpandableCard(
                        title: 'invoice_notes'.tr(),
                        icon: IconPath.vdSummuryDesc,
                        children: const [InvoiceNotesList()],
                      ),
                  ],
                ),
              );
            }
            return Center(
              child: ReloadWidget(
                onTab: () {
                  context.read<InvoiceDetailsCubit>().getInvoiceDetailsById(
                        widget.invoiceId,
                        widget.crNumber,
                        widget.crType,
                        widget.xSourceApp,
                      );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class InvoiceViolationsList extends StatelessWidget {
  const InvoiceViolationsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceDetailsCubit, InvoiceDetailsState>(
      builder: (context, state) {
        return (state.invoice?.violations?.length ?? 0) > 0
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: state.invoice?.violations?.length ?? 0,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        FieldData(
                          title: "invoice_violation_no".tr(),
                          subTitle:
                              state.invoice?.violations?[index].violationNumber,
                          radius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8)),
                        ),
                        FieldData(
                          title: "invoice_violation_date".tr(),
                          subTitle: state.invoice?.violations?[index]
                                  .violationIssueDate
                                  ?.toyMD() ??
                              "",
                          radius: BorderRadius.zero,
                        ),
                        FieldData(
                          title: "invoice_last_objection_date".tr(),
                          subTitle: state.invoice?.violations?[index]
                                  .objectionLastApplyDate
                                  ?.toyMD() ??
                              "",
                          radius: BorderRadius.zero,
                        ),
                        FieldData(
                            title: "invoice_violation_amount".tr(),
                            subTitle: state
                                    .invoice?.violations?[index].violationAmount
                                    .toString() ??
                                "",
                            radius: BorderRadius.zero),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                              color: Color(0x80E6EFEF),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8))),
                          child: ElevatedButtonWidget.custom(
                            onPressed: () async {
                              EasyLoading.show();
                              GetTransactionDetails getObjectionDetails =
                                  GetTransactionDetails(repository: sl());
                              var failureOrSuccess = await getObjectionDetails(
                                  TransactionDetailsParams(
                                      applicationId: state
                                              .invoice
                                              ?.violations?[index]
                                              .applicationId ??
                                          "",
                                      id: state.invoice?.violations?[index]
                                              .violationNumber ??
                                          ""));

                              await failureOrSuccess.fold((failure) {
                                EasyLoading.dismiss();
                              }, (success) async {
                                EasyLoading.dismiss();
                                NavigationService.navigatorKey.currentState!
                                    .pushNamed(RouteName.transactionDetailsPage,
                                        arguments: CreateObjectionPageParams(
                                            details: success));
                              });
                              return;
                            },
                            text: "invoice_show_details".tr(),
                          ),
                        ),
                      ],
                    ),
                  );
                })
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextWidget(
                      "no_violations_on_invoice".tr(),
                      fontColor: AppColor.blackModern500Light,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              );
      },
    );
  }
}

class InvoiceObjectionsList extends StatelessWidget {
  const InvoiceObjectionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceDetailsCubit, InvoiceDetailsState>(
      builder: (context, state) {
        return (state.invoice?.objections?.length ?? 0) > 0
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: state.invoice?.objections?.length ?? 0,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        FieldData(
                          title: "invoice_order_no".tr(),
                          subTitle: state
                              .invoice?.objections?[index].requestNumberAsText,
                          radius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8)),
                        ),
                        FieldData(
                          title: "invoice_violation_no".tr(),
                          subTitle: state.invoice?.objections?[index]
                                  .objectedTransactionNumber ??
                              "",
                          radius: BorderRadius.zero,
                        ),
                        FieldData(
                          title: "invoice_objection_date".tr(),
                          subTitle: state
                                  .invoice?.objections?[index].creationDate
                                  ?.toyMD() ??
                              "",
                          radius: BorderRadius.zero,
                        ),
                        FieldData(
                            title: "invoice_violation_status".tr(),
                            subTitle: state.invoice?.objections?[index]
                                    .requestStatusName
                                    .toString() ??
                                "",
                            radius: BorderRadius.zero),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                              color: Color(0x80E6EFEF),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8))),
                          child: ElevatedButtonWidget.custom(
                            onPressed: () async {
                              Navigator.of(context).pushNamed(
                                RouteName.objectionsDetailsPage,
                                arguments: {
                                  "objectionRequestNumber": state
                                          .invoice
                                          ?.objections?[index]
                                          .requestNumberAsText ??
                                      "",
                                },
                              );
                              return;
                            },
                            text: "invoice_show_details".tr(),
                          ),
                        ),
                      ],
                    ),
                  );
                })
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextWidget(
                      "no_objections_on_invoice".tr(),
                      fontColor: AppColor.blackModern500Light,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              );
      },
    );
  }
}

class InvoiceNotesList extends StatelessWidget {
  const InvoiceNotesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceDetailsCubit, InvoiceDetailsState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomVerticalSpace(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    "saddad_before".tr().replaceAll(
                        "{}", state.invoice?.dueDate?.toyMD() ?? ""),
                    fontColor: AppColor.blackModern500Light,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            CustomVerticalSpace(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomTextWidget(
                  "payment_methods".tr(),
                  fontWeight: AppFontWeight.bold,
                  fontColor: AppColor.blackModern500Light,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            PaymentOptionWidget(
              icon: ImagePath.madaVisaMaster,
              title: "invoice_criedt_note".tr(),
            ),
            CustomVerticalSpace(height: 16),
            PaymentOptionWidget(
              icon: ImagePath.sadadLogoAr,
              title: "invoice_sadad_note".tr(),
            ),
          ],
        );
      },
    );
  }
}

class PaymentOptionWidget extends StatelessWidget {
  final String title;
  final String icon;

  const PaymentOptionWidget(
      {super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColor.primary900Light),
        ),
        CustomHorizontalSpace(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomVerticalSpace(height: 16),
              icon.endsWith("svg") ? SvgPicture.asset(icon) : Image.asset(icon),
              CustomVerticalSpace(height: 16),
              CustomTextWidget(
                title,
                fontColor: AppColor.blackModern500Light,
                textAlign: TextAlign.start,
                maxLines: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
