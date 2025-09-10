import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/stream_audio/data/datasource/arriving_soon.dart';
import 'package:mapness/features/stream_audio/ui/widgets/mbc_mood.dart';
import 'package:mapness/widgets/landing/dashboard_title.dart';
import 'package:mapness/widgets/stories/lib/stories_row.dart';

@RoutePage()
class MediaCatalogPage extends StatelessWidget {
  const MediaCatalogPage({super.key});

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
            backgroundColor: context.colors.backgroundSurface3,
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
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: (_, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: ListTile(
                        leading:
                            Assets.images.audioPlaceholders.arabiya.image(),
                        title: Text('Al Arabiya FM'),
                        subtitle: Text('Noon program'),
                        trailing: Icon(Icons.reorder),
                      ),
                    ),
                  ),
                  StoriesRow(
                    onThumbnailPressed: (id)  {},
                    stories: mockStories,
                    titleWidget: const DashboardTitle( 'Arriving soon')
                  ),
                ],
              ),
            ),
        ),
      );
}

