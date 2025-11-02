import 'package:auto_route/annotations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/saudi_pass/providers/favourite_offers_screen_view_riverpod.dart';
import 'package:mapness/features/saudi_pass/widgets/favourite_offers_screen_view_widget.dart';

@RoutePage()
class FavouriteOffersScreenViewPage extends ConsumerWidget {
  const FavouriteOffersScreenViewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => FavouriteOffersScreenViewWidget(
        ref.watch(favouriteOffersScreenViewRiverpodProvider),
      );
}
