import 'package:auto_route/annotations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/saudi_pass/providers/favourite_offers_screen_riverpod.dart';
import 'package:mapness/features/saudi_pass/widgets/favourite_offers_screen_widget.dart';

@RoutePage()
class FavouriteOffersScreenPage extends ConsumerWidget {
  const FavouriteOffersScreenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => FavouriteOffersScreenWidget(
        ref.watch(favouriteOffersScreenRiverpodProvider),
      );
}
