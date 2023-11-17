import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/widgets/service_card.dart';
import 'package:mapness/_features/poi_card/widgets/shimmer.dart';
import 'package:mapness/app/routes/iwish.dart';
import 'package:mapness/features/iwish/providers/iwish_entity.dart';

class IwishDashboardItem extends ConsumerWidget {
  final String id;

  const IwishDashboardItem({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = ref.watch(iwishEntityProvider(id));
    return entity.when(
      error: (_, __) => Center(
        child: TextButton(
          onPressed: () => ref.read(iwishEntityProvider(id).notifier).refresh(),
          child: const Text('Reload'),
        ),
      ),
      loading: () => const ShimmerEffectWidget(),
      data: (entity) => Expanded(
        child: ServiceCard(
          title: entity.title,
          image: entity.photos.firstOrNull ?? 'assets/images/iwish.png',
          isNetworkImage: entity.photos.firstOrNull != null,
          subtitle: entity.subtitle,
          onTap: () => IwishCardRoute(iwishId: entity.id).push(context),
        ),
      ),
    );
  }
}
