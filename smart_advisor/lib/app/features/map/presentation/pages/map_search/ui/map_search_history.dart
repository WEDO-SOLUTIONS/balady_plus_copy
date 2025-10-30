/*import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/features/search/ui/search_history.dart' as ui;
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:provider/provider.dart';

class MapSearchHistory extends ConsumerWidget {
  const MapSearchHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = context.read<SearchScope>();

    return ui.SearchHistory(
      onTap: (item) async {
        if (item.objectId != null) {
          final dgisController = await ref.read(dgisControllerProvider.future);
          try {
            await dgisController.searchByObjectId(
              DgisObjectIdMessage(
                objectId: int.tryParse(item.objectId ?? '') ?? 0,
                entranceId: int.tryParse(item.entranceId ?? '') ?? 0,
              ),
            );

            Metrics.logEventAdvanced(MetricsConstants.poiKeys.object,
                group: MetricsConstants.poiTag,
                action: MetricAction.tap.toString(),
                props: {'objectId': item.objectId});

            PoiMapRoute.open(
              ref.read(goRouterProvider),
              int.parse(item.objectId!),
              zoom: 18,
            );
            // ignore: avoid_catches_without_on_clauses
          } catch (e) {
            final result = await showDialog(
              barrierColor: Colors.transparent,
              useSafeArea: false,
              context: context,
              builder: (contextDialog) => ProviderScope(
                parent: ProviderScope.containerOf(context),
                child: Theme(
                  data: Theme.of(context),
                  child: MediaQuery(
                    data: MediaQuery.of(context),
                    child: Directionality(
                      textDirection: Directionality.of(context),
                      child: Localizations.override(
                        context: context,
                        child: ColoredBox(
                          color: Colors.black45,
                          child: Column(
                            children: [
                              const Spacer(),
                              ErrorSheet(
                                buttonLabel: context.l10n.tryAgain,
                                errorLabel: context.l10n.placeWasNotFound,
                                onRetry: () => Navigator.of(contextDialog).pop(true),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
            await ref.read(searchHistoryProvider(scope.value).notifier).delete(item);

            if (result as bool) {
              await ref.read(searchProvider(scope.value).notifier).fetchSuggest(item.title);
            }
          }
        } else {
          await ref.read(searchProvider(scope.value).notifier).searchByText(item.title);
        }
      },
    );
  }
}
*/