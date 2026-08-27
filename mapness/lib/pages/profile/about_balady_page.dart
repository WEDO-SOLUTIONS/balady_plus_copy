import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/utils/language_detector.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

@RoutePage()
class AboutBaladyPage extends ConsumerStatefulWidget {
  const AboutBaladyPage({super.key});

  @override
  ConsumerState<AboutBaladyPage> createState() => _AboutBaladyPageState();
}

class _AboutBaladyPageState extends ConsumerState<AboutBaladyPage> {
  /// youtube video id
  final initialVideoId = 'b4kohDdo_2c';
  final initialVideoEnId = 'DpQVsa12HxU';
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final isArabic = Helpers.isRTL();
    _controller = YoutubePlayerController(
      initialVideoId: isArabic ? initialVideoId : initialVideoEnId,
      flags: const YoutubePlayerFlags(autoPlay: false, enableCaption: false, hideControls: true),
    );
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final direction = ref.watch(uiDirectionProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.read<ThemeController>().systemOverlayStyle,
      child: Scaffold(
        backgroundColor: context.colors.backgroundSurface1,
        appBar: AppBar(
          systemOverlayStyle: context.read<ThemeController>().systemOverlayStyle,
          backgroundColor: context.colors.backgroundSurface1,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            tooltip: context.l10n.a11yBack,
            onPressed: () => context.router.pop(),
            icon: Icon(SystemIcons.arrowCornerLeftSmall, color: context.colors.foregroundDefault),
          ),
          title: SizedBox(
            width: MediaQuery.sizeOf(context).width * .42,
            child: Text(
              context.l10n.aboutApp,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        YoutubePlayer(controller: _controller, bottomActions: const []),
                        ValueListenableBuilder<YoutubePlayerValue>(
                          valueListenable: _controller,
                          builder: (context, value, child) {
                            final isPlaying = value.isPlaying;
                            final isBuffering = value.playerState == PlayerState.buffering;
                            return Stack(
                              children: [
                                if (isPlaying)
                                  Positioned.fill(
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: _controller.pause,
                                      child: const SizedBox.expand(),
                                    ),
                                  ),
                                if (!isPlaying)
                                  GestureDetector(
                                    onTap: _controller.play,
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: isBuffering
                                            ? context.colors.accentOnAccent
                                            : context.colors.accentDefault,
                                        borderRadius: BorderRadius.circular(RadiusBorder.xl),
                                      ),
                                      child: Center(
                                        child: isBuffering
                                            ? SizedBox(
                                                width: 18,
                                                height: 18,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  color: context.colors.accentDefault,
                                                ),
                                              )
                                            : Icon(
                                                Icons.play_arrow_rounded,
                                                size: 24,
                                                color: context.colors.backgroundSurface1,
                                              ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(Spacing.$4x, Spacing.$4x, Spacing.$4x, Spacing.$16x),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.aboutBaladyHeading,
                          textDirection: direction,
                          style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
                        ),
                        const SizedBox(height: Spacing.$2x),
                        Text(
                          context.l10n.aboutBaladyIntro,
                          textDirection: direction,
                          style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundDefault),
                        ),
                        const SizedBox(height: Spacing.$1_5x),
                        Text(
                          context.l10n.aboutBaladyDescription,
                          textDirection: direction,
                          style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundDefault),
                        ),
                        const SizedBox(height: Spacing.$1_5x),
                        Text(
                          context.l10n.aboutBaladyFeedback,
                          textDirection: direction,
                          style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundDefault),
                        ),
                        const SizedBox(height: Spacing.$2x),
                        Text(
                          context.l10n.aboutBaladyFeaturesTitle,
                          textDirection: direction,
                          style: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
                        ),
                        const SizedBox(height: Spacing.$2x),
                        Text(
                          context.l10n.aboutBaladyFeaturesBody,
                          textDirection: direction,
                          style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundDefault),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        context.colors.gradientBackgroundSurface1opacity0,
                        context.colors.gradientBackgroundSurface1opacity80,
                      ],
                    ),
                  ),
                  child: const SizedBox(height: 72, width: double.infinity),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}