import 'package:balady_plus/etmam_app/core/dependency_injection/injection_container.dart'
    show sl;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show SearchTextFieldWidget;
import 'package:balady_plus/etmam_app/core/utils/Debouncer.dart';
import 'package:balady_plus/etmam_app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/features/home/home_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;

import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show CommonFunctions, CommonProperties, trans, IconPath;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomAppBar,
        CustomLoadingWidget,
        CustomShimmerListWidget,
        EmptyStateWidget;
import 'package:balady_plus/etmam_app/features/providers/providers_exports.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/features/_shared_feature_/presentation/widgets/search_text_field_widget.dart';

class ProvidersPage extends StatefulWidget {
  //final ProviderResponse providerResponse;
  ProvidersPage({
    Key? key,
    //required this.providerResponse,
  }) : super(key: key);

  @override
  State<ProvidersPage> createState() => _ProvidersPageState();
}

class _ProvidersPageState extends State<ProvidersPage> {
  final ScrollController _scrollController = new ScrollController();
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.ProvidersListPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(title: trans("service_providers")),
        body: BlocProvider(
          create: (context) => ProvidersBloc(
            getProvider: sl(),
            getProviderDetails: sl(),
            scrollController: _scrollController,
            // response: widget.providerResponse
          ),
          child: BlocConsumer<ProvidersBloc, ProviderState>(
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
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: SearchTextFieldWidget(
                            hintText: "ابحث",
                            containerHeight: 50,
                            onTextChanged: (String? text) {
                              if (text != state.name)
                                _debouncer.run(() {
                                  context.read<ProvidersBloc>().add(
                                      GetTopProvidersEvent(
                                          params: TopRatedProviderParams(
                                              cityId: CommonProperties.cityId,
                                              pageSize: "10",
                                              name: text,
                                              pageIndex: "1")));
                                });
                            },
                            onSubmitSearch: () {}),
                      ),
                      Expanded(
                        child: ListView.builder(
                            controller: _scrollController,
                            itemCount: (state.items?.length ?? 0) + 1,
                            itemBuilder: (ctx, index) {
                              if (index >= (state.items?.length ?? 0)) {
                                if (state.status == BlocStatus.loadMore) {
                                  return const SizedBox(
                                    height: 50,
                                    child: Center(child: CustomLoadingWidget()),
                                  );
                                } else {
                                  return Container(height: 50);
                                }
                              }

                              return ProviderItemWidget(
                                providerTotalEvaluation:
                                    state.items![index].totalEvaluationNumber,
                                providerRating:
                                    state.items![index].ratingAverage,
                                providerName:
                                    state.items![index].serviceProviderName,
                                providerIcon: state.items![index].logoImageUrl,
                                contact: state.items![index].contact,
                                onPressView: () {
                                  context.read<ProvidersBloc>().add(
                                      GetPRoviderDetailsEvent(
                                          params: ProviderDetailsParams(
                                              cityId: CommonProperties.cityId,
                                              providerId:
                                                  state.items![index].id!)));
                                },
                              );
                            }),
                      ),
                    ],
                  ),
                  if (state.status == BlocStatus.loading)
                    const CustomLoadingWidget(),
                  if (state.status == BlocStatus.loadingShimmer)
                    CustomShimmerListWidget(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      height: 225,
                      itemCount: 10,
                    ),
                  if (state.items?.isEmpty ??
                      true && state.status == BlocStatus.success)
                    Container(
                        padding:
                            const EdgeInsets.only(left: 16, right: 16, top: 24),
                        child: EmptyStateWidget(
                          img: IconPath.emptyServicesLogo,
                          title: trans('no_result'),
                          desc: "",
                        ))
                ],
              );
            },
          ),
        ));
  }
}
