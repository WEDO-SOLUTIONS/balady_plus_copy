import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/core/utils/common_functions.dart';
import 'package:balady_plus/etmam_app/core/utils/common_properties.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;
import 'package:balady_plus/etmam_app/features/my_orders/presentation/widgets/order_details/other_info_section_widget.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart';
import 'package:balady_plus/etmam_app/features/submit_request/domain/entities/submit/submit_page_params.dart';
import 'package:balady_plus/etmam_app/features/submit_request/domain/entities/submit/submit_params.dart';
import 'package:balady_plus/etmam_app/features/submit_request/presentation/blocs/relation/relation_bloc.dart';
import 'package:balady_plus/etmam_app/features/submit_request/presentation/blocs/submit_request/bloc/submit_request_bloc.dart';
import 'package:balady_plus/etmam_app/features/submit_request/submit_request_exports.dart'
    show
        PersonalInfoWidget,
        ProviderOfficeWidget,
        ServiceDetailsWidget,
        WhiteCardWidget;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/etmam_app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../core/utils/utils_exports.dart' show PrimaryIcons, trans;
import '../../../_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomAppBar,
        CustomLoadingWidget,
        CustomStackFooterButtonWidget,
        CustomVerticalSpace,
        ReloadWidget,
        SectionTitleWidget;

import '../../submit_request_exports.dart' show RelationBloc;
import '../widgets/submit_request/form_item_widget.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class SubmitRequestPage extends StatefulWidget {
  const SubmitRequestPage({Key? key}) : super(key: key);

  @override
  State<SubmitRequestPage> createState() => _SubmitRequestPageState();
}

class _SubmitRequestPageState extends State<SubmitRequestPage> {
  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.SubmitRequestPage);
  }

  @override
  Widget build(BuildContext context) {
    SubmitPageParams args =
        ModalRoute.of(context)!.settings.arguments as SubmitPageParams;

    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: trans('etmam_order_info'),
      ),
      body: BlocProvider(
        create: (context) {
          var relationBloc;
          try {
            relationBloc = args.releationBloc;
          } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

          return SubmitRequestBloc(
              relationBloc: relationBloc,
              submitRequest: sl(),
              createBiddingForm: sl(),
              args: args,
              sendOTP: sl(),
              getFormFieldData: sl(),
              validateDynamicForm: sl());
        },
        child: BlocConsumer<SubmitRequestBloc, SubmitRequestState>(
          listener: (context, state) {
            if (state.status == BlocStatus.failure) {
              CommonFunctions.showError(state.errorMessage ?? "");
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                //  body
                const SubmitRequestBody(),
                // submit button
                CustomStackFooterButtonWidget(
                  btnText: trans('confirm_order'),
                  onPressed: () {
                    if (state.form == null) {
                      context.read<SubmitRequestBloc>().add(SubmitEvent(
                          params: SubmitParams(
                              cityId: CommonProperties.cityId,
                              providerId: state.serviceProviderId,
                              relationId: state.relationId,
                              changeProvider: state.changeProvider,
                              pageType: args.pageType,
                              orderId: state.orderId,
                              subOrders: state.getSubOrders(),
                              formId: state.form?.id,
                              fields: state.form?.getFieldsRequest())));
                    } else {
                      context.read<SubmitRequestBloc>().add(ValidateFormEvent(
                          params: SubmitParams(
                              cityId: CommonProperties.cityId,
                              providerId: state.serviceProviderId,
                              relationId: state.relationId,
                              changeProvider: state.changeProvider,
                              pageType: args.pageType,
                              orderId: state.orderId,
                              subOrders: state.getSubOrders(),
                              formId: state.form?.id,
                              fields: state.form?.getFieldsRequest())));
                    }
                  },
                ),
                if (state.status == BlocStatus.loading)
                  const CustomLoadingWidget()
              ],
            );
          },
        ),
      ),
    );
  }
}

class SubmitRequestBody extends StatelessWidget {
  const SubmitRequestBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmitRequestBloc, SubmitRequestState>(
      builder: (context, state) {
        List<RelationItem>? subRelation = state.getSelectedSubOrders();
        return SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                padding: const EdgeInsets.only(bottom: 90),
                child: Column(
                  children: [
                    ProviderOfficeWidget(
                        providerServiceName: state.serviceProviderName ?? "",
                        subServiceName: state.subServiceName ?? ""),
                    const PersonalInfoWidget(),
                    OtherInfoSectionWidget(
                      city: CommonProperties.cityItem?.name,
                    ),
                    if ((subRelation?.length ?? 0) > 0)
                      Column(children: [
                        SectionTitleWidget(
                          title: trans('order_extra_services'),
                          primaryIcon: PrimaryIcons.extraServicesIcon,
                        ),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: subRelation?.length ?? 0,
                          itemBuilder: (ctx, index) => Column(
                            children: [
                              ServiceDetailsWidget(
                                serviceName: subRelation?[index].name,
                                providerName: subRelation?[index]
                                    .selectedServiceProvider
                                    ?.serviceProviderName,
                                providerEvaluation: subRelation?[index]
                                    .selectedServiceProvider
                                    ?.ratingsCount,
                                providerRating: subRelation?[index]
                                    .selectedServiceProvider
                                    ?.ratingAverage,
                                providerIconUrl: subRelation?[index]
                                    .selectedServiceProvider
                                    ?.logoImageUrl,
                                showDelete: //true,
                                    !(subRelation?[index].mandatory ?? false),
                                onDelete: () {
                                  if (subRelation?[index].id != null)
                                    context.read<SubmitRequestBloc>().add(
                                        DeleteSubReleation(
                                            id: subRelation![index].id!));
                                },
                              ),
                              CustomVerticalSpace(height: 16)
                            ],
                          ),
                        ),
                      ]),

                    // Form
                    if (state.formStatus == BlocStatus.failure)
                      ReloadWidget(onTab: () {
                        context
                            .read<SubmitRequestBloc>()
                            .add(CreateFormEvent());
                      }),

                    if (state.formStatus == BlocStatus.success &&
                        state.form != null)
                      DelgateFormItemWidget(
                        form: state.form!,
                      )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
