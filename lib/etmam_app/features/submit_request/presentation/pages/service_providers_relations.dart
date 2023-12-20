import 'package:balady_plus/etmam_app/core/dependency_injection/injection_container.dart'
    show sl;
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show SearchTextFieldWidget;
import 'package:balady_plus/etmam_app/core/utils/Debouncer.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomAppBar,
        CustomStackFooterButtonWidget,
        CustomLoadingWidget,
        EmptyStateWidget;
import 'package:balady_plus/etmam_app/features/submit_request/data/models/relation/provider_relation_page_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show CommonFunctions, CommonProperties, trans, IconPath
    hide CommonFunctions;
import '../../../../../app/features/_shared_feature_/presentation/widgets/search_text_field_widget.dart';
import '../../../../core/utils/utils_exports.dart' show CommonFunctions, trans;
import '../../submit_request_exports.dart'
    show
        ServiceTypeCardWidget,
        ServiceProvidersBloc,
        ServiceProvidersState,
        GetServicesReleationsEvent,
        SelectServiceProviderEvent;

class ServiceProvidersRelations extends StatefulWidget {
  const ServiceProvidersRelations({Key? key}) : super(key: key);

  @override
  State<ServiceProvidersRelations> createState() =>
      _ServiceProvidersRelations();
}

class _ServiceProvidersRelations extends State<ServiceProvidersRelations> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(
    //   AppEvents.ServiceProvidersRelationsPage);
  }

  @override
  Widget build(BuildContext context) {
    ProviderRelationPageParams args = ModalRoute.of(context)!.settings.arguments
        as ProviderRelationPageParams;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: trans('orders_service_providers'),
      ),
      body: BlocProvider(
        create: (context) => ServiceProvidersBloc(
            response: args.serviceProviders,
            getServicesProvidersByService: sl(),
            scrollController: _scrollController,
            selectedProviderId: args.selectedProviderId),
        child: BlocConsumer<ServiceProvidersBloc, ServiceProvidersState>(
          listener: (context, state) {
            // TODO: implement listener
            if (state.status == BlocStatus.failure) {
              CommonFunctions.showError(state.errorMessage ?? "");
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                //  body
                ServiceTypesBody(scrollContrller: _scrollController),
                // submit button
                CustomStackFooterButtonWidget(
                  btnText: trans('add'),
                  isBtnDisabled: !state.isFormValid(),
                  onPressed: () {
                    Navigator.pop(context, state.selectedItem);
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

class ServiceTypesBody extends StatefulWidget {
  final ScrollController scrollContrller;

  const ServiceTypesBody({Key? key, required this.scrollContrller})
      : super(key: key);

  @override
  State<ServiceTypesBody> createState() => _ServiceTypesBodyState();
}

class _ServiceTypesBodyState extends State<ServiceTypesBody> {
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceProvidersBloc, ServiceProvidersState>(
      builder: (context, state) {
        print(state.totalPageCount);
        return Stack(
          // padding: const EdgeInsets.only(bottom: 90),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 90),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SearchTextFieldWidget(
                        hintText: trans("search"),
                        containerHeight: 50,
                        onTextChanged: (String? text) {
                          if (text != state.name)
                            _debouncer.run(() {
                              context
                                  .read<ServiceProvidersBloc>()
                                  .add(GetServicesReleationsEvent(name: text));
                              ;
                              //  setState(() {});
                            });
                        },
                        onSubmitSearch: () {}),
                  ),
                  Expanded(
                    child: ListView.builder(
                        controller: widget.scrollContrller,
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
                          return ServiceTypeCardWidget(
                            providerIcon: state.items![index].logoImageUrl,
                            providerName:
                                state.items![index].serviceProviderName,
                            providerRating: state.items![index].ratingAverage,
                            providerTotalEvaluation:
                                state.items![index].ratingsCount,
                            isSelected: state.items![index].isSelected,
                            onSelect: () {
                              context
                                  .read<ServiceProvidersBloc>()
                                  .add(SelectServiceProviderEvent(
                                    index: index,
                                  ));
                            },
                          );
                        }),
                  ),
                ],
              ),
            ),
            if (state.status == BlocStatus.loading) const CustomLoadingWidget(),
            if (state.status == BlocStatus.failure &&
                (state.items?.isEmpty ?? true))
              Container(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
                  child: EmptyStateWidget(
                    img: IconPath.emptyServicesLogo,
                    title: trans('no_result'),
                    desc: "",
                  ))
          ],
        );
      },
    );
  }
}
