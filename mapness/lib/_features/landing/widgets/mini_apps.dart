import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/mini_apps.dart';
import 'package:mapness/entities/mini_apps/presentation_mode.dart';
import 'package:mapness/shared/config/package_config.dart';

class MiniAppsList extends ConsumerWidget {
  const MiniAppsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 16,
              left: 16,
            ),
            child: Text(
              'Mini-apps catalogue',
              style: context.textStyle.heading2.copyWith(
                color: context.color.textAndIconsBasePrimary,
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) => MiniAppCard(
                onTap: () {
                  MiniAppRoute(
                    index.isEven ? MiniAppPresentation.bottomSheet : MiniAppPresentation.fullScreen,
                    index.isEven ? 'Yandex Go' : 'Domino\'s Pizza',
                  ).push(context);
                },
                title: index.isEven ? 'Yandex Go' : 'Domino\'s Pizza',
                subtitle: index.isEven ? 'Taxi app' : 'food delivery',
                image: index.isEven ? 'assets/images/yango.png' : 'assets/images/domino.png',
              ),
            ),
          ),
        ],
      );
}

class MiniAppCard extends StatelessWidget {
  const MiniAppCard({
    required this.onTap,
    required this.title,
    required this.subtitle,
    required this.image,
    super.key,
  });

  final Function() onTap;
  final String title;
  final String subtitle;
  final String image;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          child: Ink.image(
            image: AssetImage(
              image,
              package: PackageConfig.packageName,
            ),
            fit: BoxFit.cover,
            child: InkWell(
              onTap: onTap,
              child: SizedBox(
                width: 163,
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Text(
                        title,
                        style: context.textStyle.callout.copyWith(
                          color: const Color(0xFF1E2A36),
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        subtitle,
                        style: context.textStyle.footNote.copyWith(
                          color: const Color(0xA31E2A36),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
