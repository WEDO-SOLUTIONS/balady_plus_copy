// import 'dart:math' as math;
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/stream_audio/ui/stream_audio_colors.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';
import 'package:mapness/features/stream_audio/ui/widgets/channel_item.dart';
import 'package:mapness/features/stream_audio/ui/widgets/mbc_mood.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/landing/dashboard_title.dart';
import 'package:provider/provider.dart';

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
    value: context.read<ThemeController>().systemOverlayStyle,
    child: Scaffold(
      backgroundColor: context.colors.backgroundSurface4,
      appBar: BaladyTopBar(
        systemUiOverlayStyle: context.read<ThemeController>().systemOverlayStyle,
        title: Directionality.of(context) == TextDirection.rtl ? 'كتالوج الوسائط' : 'media catalog',
        onLeadingPressed: () => context.router.pop(),
        leading: Semantics(
          label: context.l10n.a11yBack,
          button: true,
          child: ExcludeSemantics(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: Spacing.$4x),
                Icon(SystemIcons.arrowCornerLeftLarge, color: context.colors.accentDefault),
                const SizedBox(width: Spacing.$4x),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: MBCMood(color: context.streamAudioColors.brandAccent),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DashboardTitle(
                    Directionality.of(context) == TextDirection.rtl ? 'مباشر الآن' : 'Live now',
                  ),
                ),
              ],
            ),
          ),
          Builder(
            builder: (_) {
              final streamAudio = ref.watch(streamAudioProvider);
              final channels = streamAudio.filteredChannels;
              final isLoading = streamAudio.isLoadingChannels;

              if (isLoading) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: context.colors.accentDefault,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          Directionality.of(context) == TextDirection.rtl ? 'تحميل المحطات...' : 'Loading channels...',
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (channels.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Directionality.of(context) == TextDirection.rtl
                              ? 'لا توجد قنوات حاليا'
                              : 'No channels right now',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            await ref.read(streamAudioProvider.notifier).getChannels(forceRefresh: true);
                          },
                          child: Text(
                            Directionality.of(context) == TextDirection.rtl ? 'إعادة المحاولة' : 'Retry',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                onReorder: (oldIndex, newIndex) => ref.read(streamAudioProvider).reorderChannels(oldIndex, newIndex),
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
                    final channelUrl =
                        channel.logo ??
                        channel.maximizedLogo ??
                        'https://assets.mbcmood.com/channels/1708604937logombc.png';

                    final programLogo = channel.currentPlayedProgram?.image;
                    final bool hasProgramLogo = programLogo != null && programLogo.isNotEmpty;
                    final programUrl = hasProgramLogo ? programLogo : channelUrl;

                    final hasProgram = channel.currentPlayedProgram != null;
                    final imagesWidth = MediaQuery.of(context).size.width * 0.25;
                    final accent = context.colors.accentDefault;
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
                                ? BorderSide(color: accent.withValues(alpha: 0.4))
                                : BorderSide.none,
                            borderRadius: BorderRadius.circular(RadiusBorder.xl),
                          ),
                          contentPadding: const EdgeInsets.only(left: 8, right: 16),
                          tileColor: context.streamAudioColors.catalogCard,
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

                          title: Text(
                            channel.name ?? context.l10n.name,
                            style: TextStyle(
                              color: isSelected ? accent : context.colors.foregroundDefault,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                channel.currentPlayedProgram?.name ??
                                    (Directionality.of(context) == TextDirection.rtl ? 'على الهواء' : 'On Air'),
                                style: TextStyle(
                                  color: isSelected ? accent.withValues(alpha: 0.7) : context.colors.foregroundDefault,
                                ),
                              ),
                              if (channel.currentPlayedProgram?.date != null)
                                Text(
                                  channel.currentPlayedProgram!.date!,
                                  style: TextStyle(
                                    color: isSelected ? accent.withValues(alpha: 0.7) : context.colors.foregroundDefault,
                                  ),
                                ),
                            ],
                          ),
                          trailing: SizedBox(
                            height: 80,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSelected) ...[
                                  Assets.icons.svg.audio.waves.svg(
                                    colorFilter: ColorFilter.mode(
                                      context.streamAudioColors.waveGradientStart,
                                      BlendMode.srcIn,
                                    ),
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
                );
            },
          ),
          const SizedBox(
            height: 24,
          ),
          DashboardTitle(
            Directionality.of(context) == TextDirection.rtl ? 'سيصل قريباً' : 'Arriving Soon',
          ),
          const ArrivingSoon(),
        ],
        ),
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
  Widget build(BuildContext context) {
    final theme = context.streamAudioColors;

    return Stack(
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
            ProgramImage(
              url: programUrl,
              withBoarder: true,
            ),
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
                        colors: [
                          Colors.black.withValues(alpha: 0.10),
                          Colors.black.withValues(alpha: 0),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: theme.playerBorder),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ],
  );
  }
}

class ArrivingSoon extends StatelessWidget {
  const ArrivingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ArrivingSoonModel> items = [
      ArrivingSoonModel(
        title: Directionality.of(context) == TextDirection.rtl
            ? 'محتوى وبرامج صوتية حسب الطلب'
            : 'On demand audio content & shows',
        image: Assets.images.audioPlaceholders.arrivingSoon.onDemand.keyName,
      ),
      ArrivingSoonModel(
        title: Directionality.of(context) == TextDirection.rtl ? 'فيديو وأخبار MBC' : 'MBC Video & News',
        image: Assets.images.audioPlaceholders.arrivingSoon.mbcVideoNews.keyName,
      ),
      ArrivingSoonModel(
        title: Directionality.of(context) == TextDirection.rtl ? 'محتوى بلدي الأصلي' : 'Original Balady Content',
        image: Assets.images.audioPlaceholders.arrivingSoon.baladyContent.keyName,
      ),
      ArrivingSoonModel(
        title: Directionality.of(context) == TextDirection.rtl ? 'بلدي على أبل كاربلاي' : 'Balady in Apple CarPlay',
        image: Assets.images.audioPlaceholders.arrivingSoon.appleCarPlay.keyName,
      ),
      ArrivingSoonModel(
        title: Directionality.of(context) == TextDirection.rtl ? 'تنبيهات السرعة' : 'Speed alerts',
        image: Assets.images.audioPlaceholders.arrivingSoon.speedAlerts.keyName,
      ),
    ];

    return Padding(
      padding: EdgeInsets.only(
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
        side: BorderSide(width: 2, color: context.colors.borderDefault),
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
            color: context.colors.accentDefault,
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
