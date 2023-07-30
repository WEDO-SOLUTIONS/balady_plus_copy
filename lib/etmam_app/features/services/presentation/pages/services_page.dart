import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show SearchTextFieldWidget;
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/etmam_app/core/dependency_injection/injection_container.dart'
    show sl;
import 'package:balady_plus/etmam_app/core/utils/Debouncer.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart'
    show AuthStatus, BlocStatus;

import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents, NavigationService;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show
        AppColor,
        AppFontWeight,
        AuthStatus,
        BlocStatus,
        CommonFunctions,
        CommonProperties,
        IconPath,
        RouteName,
        trans;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomAppBar,
        CustomLoadingWidget,
        CustomTextWidget,
        CustomVerticalSpace,
        EmptyStateWidget,
        NeedLoginWidget,
        ServicePageParams,
        showPopUpWidget;
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show
        GetRelationsEvent,
        GetServiceDetailsEvent,
        RelationParams,
        ServiceDetailsParams,
        ServiceProviderItem,
        GetServicesEvent,
        ServicesBloc,
        ServicesState;
import 'package:balady_plus/etmam_app/features/submit_request/submit_request_exports.dart'
    show SubmitPageParams;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';

import '../../../../../app/features/_shared_feature_/presentation/widgets/search_text_field_widget.dart';

class ServicesPage extends StatefulWidget {
  final ServicePageParams args;

  const ServicesPage({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final ScrollController _scrollController = new ScrollController();
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.ServicesListPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(title: widget.args.response?.serviceName ?? ""),
        body: BlocProvider(
          create: (context) => ServicesBloc(
              getServicesProvidersByService: sl(),
              getServiceDetails: sl(),
              getRelations: sl(),
              scrollController: _scrollController,
              response: widget.args.response!,
              changeProvider: widget.args.changeProvider,
              orderId: widget.args.orderId,
              callBack: widget.args.callBack,
              pageType: widget.args.pageType),
          child: BlocConsumer<ServicesBloc, ServicesState>(
            listener: (context, state) {
              if (state.status == BlocStatus.failure) {
                CommonFunctions.showError(state.errorMessage ?? "");
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  Column(
                    children: [
                      /*  Container(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 24),
                          child: CustomTextWidget(
                            trans('service_provider_desc'),
                            fontWeight: AppFontWeight.regular,
                            fontSize: 16,
                            fontColor: AppColor.bottomNavigationShadow,
                            textAlign: TextAlign.start,
                          )),*/
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 16),
                        child: SearchTextFieldWidget(
                            hintText: "ابحث",
                            containerHeight: 50,
                            onTextChanged: (String? text) {
                              if (text != state.name)
                                _debouncer.run(() {
                                  context
                                      .read<ServicesBloc>()
                                      .add(GetServicesEvent(name: text));
                                  ;
                                  //  setState(() {});
                                });
                            },
                            onSubmitSearch: () {}),
                      ),
                      const CustomVerticalSpace(height: 16),
                      if (state.items?.isNotEmpty ?? false)
                        Expanded(
                          child: ListView.builder(
                              controller: _scrollController,
                              itemCount: (state.items?.length ?? 0) + 1,
                              itemBuilder: (ctx, index) {
                                if (index >= (state.items?.length ?? 0)) {
                                  if (state.status == BlocStatus.loadMore) {
                                    return const SizedBox(
                                      height: 50,
                                      child:
                                          Center(child: CustomLoadingWidget()),
                                    );
                                  } else {
                                    return Container(height: 50);
                                  }
                                }
                                return ServiceProviderItem(
                                  buttonTxt: widget.args.changeProvider == true
                                      ? trans('choose_office')
                                      : trans("delegate"),
                                  providerTotalEvaluation:
                                      state.items![index].ratingsCount,
                                  providerRating:
                                      state.items![index].ratingAverage,
                                  providerName:
                                      state.items![index].serviceProviderName,
                                  providerIcon:
                                      state.items![index].logoImageUrl,
                                  contact: state.items![index].contact,
                                  onPressView: widget.args.changeProvider ==
                                          true
                                      ? () {}
                                      : () {
                                          context.read<ServicesBloc>().add(
                                              GetServiceDetailsEvent(
                                                  params: ServiceDetailsParams(
                                                      serviceProviderId: state
                                                          .items![index].id!,
                                                      cityId: CommonProperties
                                                          .cityId,
                                                      subServiceId: state
                                                          .subServiceId!)));
                                        },
                                  onDelegate: () {
                                    if (!CommonProperties.isUserLogged) {
                                      showPopUpWidget(context,
                                          popUpBody: NeedLoginWidget(
                                            withMargin: false,
                                            onSuccessLogin: (bool? isSuccess) {
                                              if (isSuccess == true) {
                                                Navigator.of(context).pop();

                                                if (widget
                                                        .args.changeProvider ==
                                                    true) {
                                                  NavigationService.pushNamed(
                                                      routeName:
                                                          EtmamRoutesNames
                                                              .orderInfo,
                                                      args: SubmitPageParams(
                                                          serviceProviderId:
                                                              state
                                                                  .items![index]
                                                                  .id!,
                                                          serviceProviderName: state
                                                                  .items![index]
                                                                  .serviceProviderName ??
                                                              "",
                                                          subServiceId: state
                                                              .subServiceId,
                                                          relationId: "",
                                                          subServiceName: state
                                                              .subServiceName,
                                                          subRelations: [],
                                                          changeProvider: widget
                                                              .args
                                                              .changeProvider,
                                                          orderId: widget
                                                              .args.orderId,
                                                          callBack: widget
                                                              .args.callBack,
                                                          pageType: widget
                                                              .args.pageType));
                                                } else {
                                                  context
                                                      .read<ServicesBloc>()
                                                      .add(GetRelationsEvent(
                                                          params: RelationParams(
                                                              serviceProviderId:
                                                                  state
                                                                      .items![
                                                                          index]
                                                                      .id!,
                                                              serviceProviderName: state
                                                                      .items![
                                                                          index]
                                                                      .serviceProviderName ??
                                                                  "",
                                                              cityId:
                                                                  CommonProperties
                                                                      .cityId,
                                                              subServiceId: state
                                                                  .subServiceId!)));
                                                }
                                              }
                                            },
                                          ));
                                    } else {
                                      if (widget.args.changeProvider == true) {
                                        NavigationService.pushNamed(
                                            routeName:
                                                EtmamRoutesNames.orderInfo,
                                            args: SubmitPageParams(
                                                serviceProviderId:
                                                    state.items![index].id!,
                                                serviceProviderName: state
                                                        .items![index]
                                                        .serviceProviderName ??
                                                    "",
                                                subServiceId:
                                                    state.subServiceId,
                                                relationId: "",
                                                subServiceName:
                                                    state.subServiceName,
                                                subRelations: [],
                                                changeProvider:
                                                    widget.args.changeProvider,
                                                orderId: widget.args.orderId,
                                                callBack: widget.args.callBack,
                                                pageType:
                                                    widget.args.pageType));
                                      } else {
                                        context.read<ServicesBloc>().add(
                                            GetRelationsEvent(
                                                params: RelationParams(
                                                    serviceProviderId: state
                                                        .items![index].id!,
                                                    serviceProviderName: state
                                                            .items![index]
                                                            .serviceProviderName ??
                                                        "",
                                                    cityId:
                                                        CommonProperties.cityId,
                                                    subServiceId:
                                                        state.subServiceId!)));
                                      }
                                    }
                                  },
                                );
                              }),
                        ),
                      if (state.items?.isEmpty ??
                          true && state.status == BlocStatus.success)
                        Expanded(
                          child: Container(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 24),
                              child: EmptyStateWidget(
                                img: IconPath.emptyServicesLogo,
                                title: trans('no_result'),
                                desc: "",
                              )),
                        )
                    ],
                  ),
                  BlocBuilder<EntryPointCubit, EntryPointState>(
                      bloc: sl(),
                      builder: (context, authState) {
                        return (state.status == BlocStatus.loading ||
                                authState.status == AuthStatus.loading)
                            ? const CustomLoadingWidget()
                            : Container();
                      })
                ],
              );
            },
          ),
        ));
  }
}
