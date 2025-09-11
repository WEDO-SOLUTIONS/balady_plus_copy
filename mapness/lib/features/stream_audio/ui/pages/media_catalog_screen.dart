import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/stream_audio/data/datasource/arriving_soon.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';
import 'package:mapness/features/stream_audio/ui/widgets/mbc_mood.dart';
import 'package:mapness/widgets/landing/dashboard_title.dart';
import 'package:mapness/widgets/stories/lib/stories_row.dart';

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
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
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
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Live now',
                        style: context.textStyles.h3Medium,
                      ),
                      const MBCMood(
                        color: Color.fromRGBO(242, 74, 56, 1),
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

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: programs.length,
                    itemBuilder: (_, index) {
                      final p = programs[index];
                      final imagesWidth = MediaQuery.of(context).size.width * 0.25;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(RadiusBorder.xl),
                          ),
                          contentPadding: const EdgeInsets.only(left: 8, right: 16),
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
                                        image: AssetImage(p.programImage.keyName),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black.withOpacity(0.10), width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          title: Text(p.title),
                          subtitle: Text(p.sub),
                          trailing: Assets.icons.svg.icFilter.svg(),
                        ),
                      );
                    },
                  );
                }),
                StoriesRow(
                    onThumbnailPressed: (id) {},
                    stories: mockStories,
                    titleWidget: const DashboardTitle('Arriving soon')),
              ],
            ),
          ),
        ),
      );
}
