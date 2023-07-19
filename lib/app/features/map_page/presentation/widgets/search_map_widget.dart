import 'package:balady_plus/app/features/map_page/data/model/layers.dart';
import 'package:balady_plus/app/features/map_page/presentation/mvvm/layers_gis_view_model.dart';
import 'package:balady_plus/app/features/map_page/presentation/mvvm/search_map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/enums/near_by_types.dart';
import '../../../home_page/presentation/widgets/home_tag.dart';

class SearchMapWidget extends StatelessWidget {
  final SearchMapViewModel searchMapViewModel;

  const SearchMapWidget({super.key, required this.searchMapViewModel});

  @override
  Widget build(BuildContext context) {
    LayersGisViewModel layersGisViewModel =
        context.watch<LayersGisViewModel?>()!;

    return ChangeNotifierProvider(
      create: (BuildContext context) => searchMapViewModel,
      child: Column(
        children: [
          TextFormField(
            controller: searchMapViewModel.searchController,
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
                searchMapViewModel.performSearch(queryText: text);
              }
            },
            // onChanged: (text) => searchItem(text: text),
          ),
          const SizedBox(
            height: 6,
          ),
          Selector<LayersGisViewModel, List<Layers>?>(
            selector: (_, provider) => provider.layers,
            builder: (_, layers, __) {
              return layers?.isNotEmpty ?? false
                  ? SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: layers!.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final Layers layer = layers[index];
                          return index == 0
                              ? const CircularProgressIndicator()
                              : Container(
                                  margin: const EdgeInsetsDirectional.only(
                                    start: 8,
                                    bottom: 8,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      searchMapViewModel.performSearch(
                                          queryText: layer.name);
                                    },
                                    child: HomeTag(
                                      title: layer.name,
                                      // icon: tag.icon == null
                                      //     ? null
                                      //     : IconPath.nearbyIcon(tag.icon!),
                                      // color: tag.color,
                                      selected: index == 0,
                                    ),
                                  ),
                                );
                        },
                      ),
                    )
                  : const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
