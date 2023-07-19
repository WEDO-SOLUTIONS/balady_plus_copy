import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, BlocRequestStatus, DateTimeExtension, IconPath;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show
        CardParameter,
        CustomTextWidget,
        DefaultAppBarWidget,
        DrawIconBasedTypeWidget,
        ExpandableCard,
        MessageDialog,
        ShimmerEffectWidget;
import '../../invoices_exports.dart'
    show InvoiceDetailsCubit, InvoiceDetailsState, InvoiceEntity;

class InvoiceDetailBody extends StatefulWidget {
  final InvoiceEntity invoiceEntity;
  const InvoiceDetailBody({
    super.key,
    required this.invoiceEntity,
  });

  @override
  State<InvoiceDetailBody> createState() => _InvoiceDetailBodyState();
}

class _InvoiceDetailBodyState extends State<InvoiceDetailBody> {
  @override
  void initState() {
    super.initState();
    context.read<InvoiceDetailsCubit>().getInvoiceDetailsById(
          widget.invoiceEntity.id!,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: widget.invoiceEntity.requestTypeName,
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
                          icon: IconPath.calender,
                          iconSize: 24,
                        ),
                        const SizedBox(width: 4),
                        CustomTextWidget(
                          invoice.creationDate.toWrittenDate(),
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
                                  invoice.invoiceStatusName,
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
                      icon: IconPath.aboutBalady,
                      isExpandedByDefault: true,
                      children: [
                        CardParameter(
                          title: 'invoice_no'.tr(),
                          value: invoice.accountNumber,
                        ),
                        CardParameter(
                          title: 'invoice_amount'.tr(),
                          value: '${invoice.amount} ${"sar".tr()}',
                        ),
                        if (invoice.requestNumber.isNotEmpty)
                          CardParameter(
                            title: 'request_no'.tr(),
                            value: invoice.requestNumber,
                          ),
                        CardParameter(
                          title: 'invoice_issue_date'.tr(),
                          value: invoice.creationDate.toyMD(),
                        ),
                        if (invoice.sadadDate != null)
                          CardParameter(
                            title: 'invoice_pay_date'.tr(),
                            value: invoice.sadadDate!.toyMD(),
                          ),
                        CardParameter(
                          title: 'invoice_due_date'.tr(),
                          value: invoice.dueDate.toyMD(),
                        ),
                        CardParameter(
                          title: ("نوع الرخصة").tr(),
                          value: invoice.invoiceTypeName,
                        ),
                      ],
                    ),
                    ExpandableCard(
                      title: 'violations'.tr(),
                      icon: IconPath.aboutBalady,
                      children: const [],
                    ),
                    ExpandableCard(
                      title: 'objections'.tr(),
                      icon: IconPath.aboutBalady,
                      children: const [],
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
