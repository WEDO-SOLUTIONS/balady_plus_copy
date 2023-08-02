import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show NearByTypes;
import '../../nearby_exports.dart' show NearbyItem;
import 'package:balady_plus/app/features/nearby/presentation/mvvm/nearby_view_model.dart';
import 'package:provider/provider.dart';

class NearbyGrid extends StatelessWidget {
  const NearbyGrid({super.key});

  @override
  Widget build(BuildContext context) {
    NearByViewModel nearByViewModel = context.watch<NearByViewModel>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Selector<NearByViewModel, bool>(
        selector: (_, provider) => provider.isSearchLoading.value,
        builder: (_, isLoading, __) {
          return isLoading
              ? const Center(child: CircularProgressIndicator())
              : nearByViewModel.searchResultMessage.value?.firstPage?.items.isNotEmpty ??
                      false
                  ? GridView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: nearByViewModel.searchResultMessage.value!.firstPage!.items.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.1,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemBuilder: (context, index) {
                        DirectoryObjectMessage item = nearByViewModel.searchResultMessage.value!.firstPage!.items[index]!;
                        return NearbyItem(
                          title: item.title,
                          subtitle: item.subtitle,
                          type: NearByTypes.mosque,
                        );
                      },
                    )
                  : const Center(child: Text('no data'));
        },
      ),
    );
  }
}
