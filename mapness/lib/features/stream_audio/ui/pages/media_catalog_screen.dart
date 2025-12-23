// import 'dart:math' as math;
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';
import 'package:mapness/features/stream_audio/ui/widgets/channel_item.dart';
import 'package:mapness/features/stream_audio/ui/widgets/mbc_mood.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
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
    Future.microtask(() => ref.read(streamAudioProvider).getChannels());
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: BaladyTopBar.iconAndText(
            systemUiOverlayStyle: SystemUiOverlayStyle.dark,
            //TODO: Add to localization MBC
            // title: context.l10n.mediaSub,
            title: 'MBC Mood',
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
                    const DashboardTitle(
                      //TODO: Add to localization MBC
                      //   context.l10n.liveNow
                      'Live Now',
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: MBCMood(color: Color.fromRGBO(242, 74, 56, 1)),
                    )
                  ],
                ),
              ),
              Builder(builder: (_) {
                final channels = ref.watch(streamAudioProvider).filteredChannels;
                if (channels.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                        //TODO: Add to localization MBC
                        //   context.l10n.noChannels
                        'No Channels'
                    ),
                  );
                }

                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.44,
                  child: ReorderableListView.builder(
                    shrinkWrap: true,
                    onReorder: (oldIndex, newIndex) =>
                        ref.read(streamAudioProvider).reorderChannels(oldIndex, newIndex),
                    itemCount: channels.length,
                    proxyDecorator: (child, index, animation) => Material(
                      type: MaterialType.transparency,
                      surfaceTintColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      child: child,
                    ),
                    itemBuilder: (_, index) {
                      final channel = channels[index];
                      final bool isSelected = ref.watch(streamAudioProvider).selectedChannel?.id == channel.id;
                      final channelUrl = channel.circledLogo ??
                          channel.maximizedLogo ??
                          'https://assets.mbcmood.com/channels/1708604937logombc.png';

                      final programLogo = channel.currentPlayedProgram?.image;
                      final bool hasProgramLogo = programLogo != null && programLogo.isNotEmpty;
                      final programUrl = hasProgramLogo
                          ? programLogo
                          : (channel.maximizedLogo ?? 'https://assets.mbcmood.com/channels/1708604937logombc.png');

                      final hasProgram = channel.currentPlayedProgram != null;
                      final imagesWidth = MediaQuery.of(context).size.width * 0.25;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                        key: ValueKey(channel.id),
                        child: Material(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(RadiusBorder.xl),
                          ),
                          shadowColor: const Color(0x19000000),
                          child: ListTile(
                            minTileHeight: 80,
                            // onTap: () => ref.read(streamAudioProvider).selectProgram(p),
                            onTap: () {
                              if (!isSelected) {
                                ref.read(streamAudioProvider).selectChannel(channel);
                              }
                            },
                            shape: RoundedRectangleBorder(
                              side: isSelected
                                  ? BorderSide(color: const Color(0xff9547E9).withOpacity(0.4))
                                  : BorderSide.none,
                              borderRadius: BorderRadius.circular(RadiusBorder.xl),
                            ),
                            contentPadding: const EdgeInsets.only(left: 8, right: 16),
                            tileColor: Colors.white,
                            minLeadingWidth: imagesWidth,
                            leading: SizedBox(
                              width: imagesWidth,
                              child: MediaImages(
                                      imagesWidth: imagesWidth,
                                      programUrl: programUrl,
                                      channelUrl: channelUrl,
                                      hasProgram: hasProgram,
                                    ),
                            ),

                            title: Text(channel.name ?? context.l10n.name,
                                style: TextStyle(color: isSelected ? const Color(0xff9547E9) : null)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(channel.currentPlayedProgram?.name ??
                                //TODO: Add to localization MBC
                                //     context.l10n.onAir,
                                'On Air',
                                    style: TextStyle(
                                        color: isSelected ? const Color(0xff9547E9).withOpacity( 0.7) : null)),
                                if (channel.currentPlayedProgram?.date != null)
                                  Text(channel.currentPlayedProgram!.date!,
                                      style: TextStyle(
                                          color: isSelected ? const Color(0xff9547E9).withOpacity( 0.7) : null)),
                              ],
                            ),
                            trailing: SizedBox(
                              height: 80,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isSelected) ...[
                                    Assets.icons.svg.audio.waves.svg(
                                      colorFilter: const ColorFilter.mode(Color(0xff9547E9), BlendMode.srcIn),
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
              const SizedBox(
                height: 24,
              ),
              const DashboardTitle(
                //TODO: Add to localization MBC
                //   context.l10n.arrivingSoon
                'Arriving Soon',
              ),
              const ArrivingSoon()
            ],
          ),
        ),
      );
}

class MediaImages extends StatelessWidget {
  const MediaImages({
    required this.imagesWidth,
    required this.programUrl,
    required this.channelUrl,
    required this.hasProgram,
    super.key,
  });

  final double imagesWidth;
  final bool hasProgram;
  final String programUrl;
  final String channelUrl;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Positioned(
            height: (imagesWidth / 2) + 4,
            width: (imagesWidth / 2) + 4,
            child: CircleImage(url: channelUrl),
          ),
          Positioned(
              top: 6,
              right: CommonFunctions.isAppAR ? null : 12,
              left: CommonFunctions.isAppAR ? 12 : null,
              height: (imagesWidth / 2) - 4,
              width: (imagesWidth / 2) - 4,
              child: Stack(
                children: [
                  ProgramImage(url: programUrl, withBoarder: true,),
                  if (!hasProgram)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 1.4, sigmaY: 1.4),
                        child: Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: const Alignment(0.50, -0.00),
                              end: const Alignment(0.50, 1.00),
                              stops: const [0.00, 1.00],
                              colors: [Colors.black.withOpacity( 0.10), Colors.black.withOpacity( 0)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.black.withOpacity( 0.10),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              )),
        ],
      );
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
        image: Assets.images.audioPlaceholders.arrivingSoon.mbcVideoNews.keyName,
      ),
      ArrivingSoonModel(
        title: 'Original Balady Content',
        image: Assets.images.audioPlaceholders.arrivingSoon.baladyContent.keyName,
      ),
      ArrivingSoonModel(
        title: 'Balady in Apple CarPlay',
        image: Assets.images.audioPlaceholders.arrivingSoon.appleCarPlay.keyName,
      ),
      ArrivingSoonModel(
        title: 'Speed alerts',
        image: Assets.images.audioPlaceholders.arrivingSoon.speedAlerts.keyName,
      ),
    ];

    return Padding(
      padding:  EdgeInsets.only(
        top: 16.0,
        bottom: 16.0,
        left: CommonFunctions.isAppAR ? 0 : 14.0,
        right: CommonFunctions.isAppAR ? 14.0 : 0,
      ),
      child: SizedBox(
        height: 120,
        width: MediaQuery.of(context).size.width,
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
