import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/etmam_app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomAppBar,
        CustomCheckBoxWidget,
        CustomLoadingWidget,
        CustomStackFooterButtonWidget,
        CustomTextWidget,
        CustomVerticalSpace;
import 'package:balady_plus/etmam_app/features/services/services_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;

import '../../../../core/utils/utils_exports.dart'
    show
        AppColor,
        AppFontWeight,
        CommonFunctions,
        CommonProperties,
        IconPath,
        trans;
import '../../submit_request_exports.dart'
    show
        CheckBoxButton,
        GetProvidersByService,
        RelationBloc,
        RelationPageParam,
        RelationState,
        SelectRelationEvent,
        SelectedProviderWidget,
        SubmitPageParams,
        SubmitRequestPage;

class RelationRequestPage extends StatefulWidget {
  const RelationRequestPage({Key? key}) : super(key: key);

  @override
  State<RelationRequestPage> createState() => _RelationRequestPageState();
}

class _RelationRequestPageState extends State<RelationRequestPage> {
  @override
  void initState() {
    super.initState();
    // if (widget.args.changeProvider == true)
    //CommonFunctions.sendEventToAnalytics(AppEvents.ChangeProvider);
    //else
    //CommonFunctions.sendEventToAnalytics(AppEvents.RelationRequestPage);
  }

  @override
  Widget build(BuildContext context) {
    RelationPageParam args =
        ModalRoute.of(context)!.settings.arguments as RelationPageParam;

    return Scaffold(
      appBar: CustomAppBar(
        title: trans('extra_services'),
      ),
      body: BlocProvider(
        create: (context) => RelationBloc(
            relationResponse: args.relationResponse,
            getServicesProvidersByService: sl(),
            args: args),
        child: BlocConsumer<RelationBloc, RelationState>(
          listener: (context, state) {
            if (state.status == BlocStatus.failure) {
              CommonFunctions.showError(state.errorMessage ?? "");
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                //  body
                const RelationRequestBody(),
                // submit button
                CustomStackFooterButtonWidget(
                  btnText: args.changeProvider == true
                      ? trans('update_order')
                      : trans('start_request'),
                  isBtnDisabled: !state.isValidToSubmit(),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      EtmamRoutesNames.orderInfo,
                      arguments: SubmitPageParams(
                          serviceProviderId: state.serviceProviderId,
                          serviceProviderName: state.serviceProviderName,
                          subServiceId: state.subServiceId,
                          relationId: state.relationRespone?.id,
                          subServiceName: state.subServiceName,
                          subRelations: state.subRelations,
                          orderId: args.orderId,
                          callBack: args.callBack,
                          inputsRequired: state.relationRespone?.inputsRequired,
                          pageType: args.pageType,
                          releationBloc: BlocProvider.of<RelationBloc>(context),
                          changeProvider: args.changeProvider),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class RelationRequestBody extends StatelessWidget {
  const RelationRequestBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RelationBloc, RelationState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              padding: const EdgeInsets.only(bottom: 90),
              child: Column(
                children: [
                  CustomTextWidget(
                    trans('extra_services_desc'),
                    fontSize: 16,
                    fontWeight: AppFontWeight.regular,
                    fontColor: AppColor.bottomNavigationShadow,
                  ),
                  const CustomVerticalSpace(height: 16),
                  Expanded(
                    child: ListView.builder(
                        itemCount: state.subRelations?.length ?? 0,
                        itemBuilder: (ctx, index) {
                          return CustomCheckBoxWidget(
                              checkBoxText:
                                  state.subRelations?[index].name ?? "",
                              btnPressed: () {
                                if (!(state.subRelations?[index].mandatory ??
                                    false)) {
                                  context
                                      .read<RelationBloc>()
                                      .add(SelectRelationEvent(index: index));
                                }
                              },
                              isSelected: state.subRelations?[index]
                                      .isCheckedORManadatory() ??
                                  false,
                              checkBoxIcon: IconPath.serviceTempBaladyIcon,
                              checkBoxDesc: trans('order_extra_services_desc'),
                              buttonWidget: (state.subRelations?[index]
                                          .selectedServiceProvider !=
                                      null)
                                  ? SelectedProviderWidget(
                                      serviceItem: state.subRelations![index]
                                          .selectedServiceProvider!,
                                      onPressChanged: () {
                                        context.read<RelationBloc>().add(
                                            GetProvidersByService(
                                                index: index,
                                                params: ServiceParams(
                                                    cityId:
                                                        CommonProperties.cityId,
                                                    pageIndex: "1",
                                                    subServiceId: state
                                                            .subRelations?[
                                                                index]
                                                            .serviceId ??
                                                        "",
                                                    subServiceName: state
                                                        .subRelations![index]
                                                        .name!)));
                                      },
                                    )
                                  : CheckBoxButton(
                                      onPress: () {
                                        context.read<RelationBloc>().add(
                                            GetProvidersByService(
                                                index: index,
                                                params: ServiceParams(
                                                    cityId:
                                                        CommonProperties.cityId,
                                                    pageIndex: "1",
                                                    subServiceId: state
                                                            .subRelations?[
                                                                index]
                                                            .serviceId ??
                                                        "",
                                                    subServiceName: state
                                                        .subRelations![index]
                                                        .name!)));
                                      },
                                    ));
                        }),
                  ),
                ],
              ),
            ),
            if (state.status == BlocStatus.loading) const CustomLoadingWidget()
          ],
        );
      },
    );
  }
}
