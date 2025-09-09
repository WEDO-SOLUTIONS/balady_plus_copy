import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

@RoutePage()
class AboutBaladyPage extends ConsumerStatefulWidget {
  const AboutBaladyPage({super.key});

  @override
  ConsumerState<AboutBaladyPage> createState() => _AboutBaladyPageState();
}

class _AboutBaladyPageState extends ConsumerState<AboutBaladyPage> {
  ///youtube video id
  final initialVideoId = '4iRVvB1iZAc';
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: initialVideoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        enableCaption: false,
      ),
    );
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
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
      value: SystemUiOverlayStyle.dark,
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: Spacing.$4x),
          child: Scaffold(
            appBar: BaladyTopBar.iconAndText(
              systemUiOverlayStyle: SystemUiOverlayStyle.dark,
              title: context.l10n.aboutApp,
              colorEnabled: context.colors.accentDefault,
              leading: ActionModel(
                onPressed: () => context.router.popForced(),
                icon: SystemIcons.arrowCornerLeftLarge,
              ),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(Spacing.$4x),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(RadiusBorder.l),
                    child: YoutubePlayer(
                      controller: _controller,
                      bottomActions: const [
                        CurrentPosition(),
                        ProgressBar(isExpanded: true),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.l10n.weAreHappyToConnectYouWithBaladyTeam,
                          textDirection: direction,
                          style: context.textStyle.text.copyWith(
                            color: context.colors.foregroundDefault,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
