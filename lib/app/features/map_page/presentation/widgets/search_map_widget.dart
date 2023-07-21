import 'package:balady_plus/app/features/map_page/data/model/layers.dart';
import 'package:balady_plus/app/features/map_page/presentation/mvvm/layers_gis_view_model.dart';
import 'package:balady_plus/app/features/map_page/presentation/mvvm/map_view_model.dart';
import 'package:balady_plus/app/features/map_page/presentation/mvvm/search_map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/enums/near_by_types.dart';
import '../../../home_page/presentation/widgets/home_tag.dart';

class SearchMapWidget extends StatelessWidget {
  const SearchMapWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MapViewModel mapViewModel = context.watch<MapViewModel>();

    return Column(
      children: [
        TextFormField(
          controller: mapViewModel.searchController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'search'.tr(),
            fillColor: Colors.white,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            prefixIcon: const Icon(Icons.search),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none,
            ),
            disabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none,
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none,
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none,
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none,
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none,
            ),
          ),
          onFieldSubmitted: (text) {
            if (text.isNotEmpty) {
              mapViewModel.performSearch(queryText: text);
            }
          },
          // onChanged: (text) => searchItem(text: text),
        ),
        // const SizedBox(
        //   height: 6,
        // ),
        // Selector<LayersGisViewModel, List<SubLayers>?>(
        //   selector: (_, provider) => provider.subLayers,
        //   builder: (_, subLayers, __) {
        //     return subLayers?.isNotEmpty ?? false
        //         ? SizedBox(
        //             height: 40,
        //             child: ListView.builder(
        //               scrollDirection: Axis.horizontal,
        //               itemCount: subLayers!.length,
        //               padding: EdgeInsets.zero,
        //               itemBuilder: (context, index) {
        //                 final SubLayers layer = subLayers[index];
        //                   return  Container(
        //                         margin: const EdgeInsetsDirectional.only(
        //                           start: 8,
        //                           bottom: 8,
        //                         ),
        //                         child: InkWell(
        //                           onTap: () {
        //                             mapViewModel.performSearch(queryText: layer.name);
        //                             mapViewModel.subLayerSelected.value = layer;
        //                           },
        //                           child: ValueListenableBuilder<SubLayers?>(
        //                             valueListenable: mapViewModel.subLayerSelected,
        //                             builder: (_, subLayerSelected, __) {
        //                               return HomeTag(
        //                                 title: layer.name,
        //                                 color: Colors.deepPurple.shade700,
        //                                 selected: layer == subLayerSelected,
        //                               );
        //                             },
        //                           ),
        //                         ),
        //                       );
        //               },
        //             ),
        //           )
        //         : const SizedBox();
        //   },
        // ),
      ],
    );
  }
}
