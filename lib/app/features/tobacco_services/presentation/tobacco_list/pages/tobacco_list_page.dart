import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/loading_list_widget.dart';
import 'package:balady_plus/app/features/tobacco_services/data/data_sources/remote_data_source.dart';
import 'package:balady_plus/app/features/tobacco_services/data/repositories/repository_implementation.dart';
import 'package:balady_plus/app/features/tobacco_services/presentation/tobacco_list/mvvm/tobacco_list_view_model.dart';
import 'package:balady_plus/app/features/tobacco_services/presentation/tobacco_list/widgets/tobacco_list_item.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class TobaccoListPage extends StatefulWidget {
  const TobaccoListPage({super.key});

  @override
  State<TobaccoListPage> createState() => _TobaccoListPageState();
}

class _TobaccoListPageState extends State<TobaccoListPage> {
  late TobaccoListViewModel provider;

  // final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(_onScroll);
    provider = TobaccoListViewModel(
      TobaccoListRepositoryImplementation(
        remoteDataSource: TobaccoListRemoteDataSourceImplementation(
          webService: sl(),
        ),
      ),
    );
  }

  // void _onScroll() {
  //   provider.getUserFacilities();
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => provider,
      child: Scaffold(
        appBar: DefaultAppBarWidget(
          title: 'tobaccoServices'.tr(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Selector<TobaccoListViewModel, bool>(
            selector: (_, provider) => provider.isLoading,
            builder: (context, isLoading, child) {
              return isLoading
                  ? ListView.builder(
                      itemCount: 6,
                      itemBuilder: (_, __) => Container(
                        height: 200,
                        margin: const EdgeInsets.only(top: 16),
                        child: const ShimmerEffectWidget(),
                      ),
                    )
                  : provider.facilities != null
                      ? ListView.builder(
                          shrinkWrap: true,
                          // controller: _scrollController,
                          itemCount: provider.facilities!.length,
                          itemBuilder: (context, index) {
                            return TobaccoListItem(
                                facility: provider.facilities![index]);
                          },
                        )
                      : ReloadWidget(
                          errorMessage: provider.errorMessage,
                          onTab: () {
                            provider.getUserFacilities();
                          },
                        );
            },
          ),
        ),
      ),
    );
  }
}
