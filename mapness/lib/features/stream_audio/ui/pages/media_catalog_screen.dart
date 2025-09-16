import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';
import 'package:mapness/features/stream_audio/ui/widgets/mbc_mood.dart';
import 'package:mapness/widgets/landing/dashboard_title.dart';

@RoutePage()
class MediaCatalogPage extends ConsumerStatefulWidget {
  const MediaCatalogPage({super.key});

  @override
  ConsumerState<MediaCatalogPage> createState() => _MediaCatalogPageState();
}

class _MediaCatalogPageState extends ConsumerState<MediaCatalogPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(streamAudioProvider).getLiveNow());
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(streamAudioProvider);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: BaladyTopBar.iconAndText(
          systemUiOverlayStyle: SystemUiOverlayStyle.dark,
          title: 'Media Catalog',
          colorEnabled: context.color.textAndIconsStatusAccent,
          leading: ActionModel(
            onPressed: () => context.router.popForced(),
            icon: SystemIcons.arrowCornerLeftLarge,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DashboardTitle('Live now'),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: MBCMood(color: Color.fromRGBO(242, 74, 56, 1)),
                  )
                ],
              ),
            ),
            Builder(builder: (_) {
              final liveNow = ref.watch(streamAudioProvider).liveNow;
              if (liveNow == null) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final programs = liveNow.programs;
              if (programs.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No live programs right now'),
                );
              }

              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.44,
                child: ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  onReorder: ref.watch(streamAudioProvider).reorderPrograms,
                  itemCount: programs.length,
                  proxyDecorator: (child, index, animation) => Material(
                    type: MaterialType.transparency,
                    surfaceTintColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    child: child,
                  ),
                  itemBuilder: (_, index) {
                    final p = programs[index];
                    final imagesWidth =
                        MediaQuery.of(context).size.width * 0.25;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 16),
                      key: ValueKey('${p.title}-$index'),
                      child: Material(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(RadiusBorder.xl),
                        ),
                        shadowColor: const Color(0x19000000),
                        child: ListTile(
                          minTileHeight: 80,
                          onTap: () =>
                              ref.read(streamAudioProvider).selectProgram(p),
                          shape: RoundedRectangleBorder(
                            side: provider.selectedProgram?.title == p.title
                                ? BorderSide(
                                    color: const Color(0xff9547E9)
                                        .withOpacity(0.4))
                                : BorderSide.none,
                            borderRadius:
                                BorderRadius.circular(RadiusBorder.xl),
                          ),
                          contentPadding:
                              const EdgeInsets.only(left: 8, right: 16),
                          tileColor: Colors.white,
                          minLeadingWidth: imagesWidth,
                          leading: SizedBox(
                            width: imagesWidth,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  width: imagesWidth / 2,
                                  child: Container(
                                    width: 56,
                                    height: 56,
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                        image: p.channelImage.provider(),
                                        fit: BoxFit.fill,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Colors.black.withOpacity(0.10),
                                        ),
                                        borderRadius: BorderRadius.circular(48),
                                      ),
                                      shadows: const [
                                        BoxShadow(
                                          color: Color(0x19000000),
                                          blurRadius: 12,
                                          offset: Offset(0, 8),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 6,
                                  right: 12,
                                  top: 6,
                                  width: imagesWidth / 2.3,
                                  child: Container(
                                    height: 32,
                                    width: 32,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            AssetImage(p.programImage.keyName),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.black.withOpacity(0.10),
                                          width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          title: Text(p.title,
                              style: TextStyle(
                                  color:
                                      provider.selectedProgram?.title == p.title
                                          ? const Color(0xff9547E9)
                                          : null)),
                          subtitle: Text(p.sub,
                              style: TextStyle(
                                  color: provider.selectedProgram?.title ==
                                          p.title
                                      ? const Color(0xff9547E9).withOpacity(0.7)
                                      : null)),
                          trailing: SizedBox(
                            height: 80,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (provider.selectedProgram?.title ==
                                    p.title) ...[
                                  Assets.icons.svg.audio.waves.svg(
                                    colorFilter: const ColorFilter.mode(
                                        Color(0xff9547E9), BlendMode.srcIn),
                                  ),
                                  const SizedBox(width: 12),
                                ],
                                Assets.icons.svg.icFilter.svg(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
            const DashboardTitle('Arriving soon'),
            const ArrivingSoon()
          ],
        ),
      ),
    );
  }
}

class ArrivingSoon extends StatelessWidget {
  const ArrivingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ArrivingSoonModel> items = [
      ArrivingSoonModel(
        title: 'On demand audio content & shows',
        image: Assets.images.audioPlaceholders.arrivingSoon.onDemand.keyName,
      ),
      ArrivingSoonModel(
        title: 'MBC Video & News',
        image:
            Assets.images.audioPlaceholders.arrivingSoon.mbcVideoNews.keyName,
      ),
      ArrivingSoonModel(
        title: 'Original Balady Content',
        image:
            Assets.images.audioPlaceholders.arrivingSoon.baladyContent.keyName,
      ),
      ArrivingSoonModel(
        title: 'Balady in Apple CarPlay',
        image:
            Assets.images.audioPlaceholders.arrivingSoon.appleCarPlay.keyName,
      ),
      ArrivingSoonModel(
        title: 'Speed alerts',
        image: Assets.images.audioPlaceholders.arrivingSoon.speedAlerts.keyName,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 120,
        width: MediaQuery.of(context).size.width * 0.9,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ArrivingSoonItem(items[index]),
          ),
        ),
      ),
    );
  }
}

class ArrivingSoonModel {
  final String title;
  final String image;

  ArrivingSoonModel({required this.title, required this.image});
}

class ArrivingSoonItem extends StatelessWidget {
  const ArrivingSoonItem(this.item, {super.key});

  final ArrivingSoonModel item;

  @override
  Widget build(BuildContext context) => Container(
        width: 104,
        height: 120,
        padding: const EdgeInsets.all(4),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 2, color: Color(0xFF003449)),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Stack(
          children: [
            Container(
              width: 96,
              height: 112,
              padding: const EdgeInsets.all(8),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: AssetImage(item.image),
                  fit: BoxFit.fill,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Container(
              width: 96,
              height: 112,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                gradient: const LinearGradient(
                  begin: Alignment(0.50, -0.00),
                  end: Alignment(0.50, 1.00),
                  colors: [Color(0x00666666), Color(0xB2151C30)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Text(
                item.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                style: context.textStyles.captionSmallSemiBold.copyWith(
                  fontSize: 11,
                  color: context.colors.accentOnAccent,
                ),
              ),
            ),
          ],
        ),
      );
}
