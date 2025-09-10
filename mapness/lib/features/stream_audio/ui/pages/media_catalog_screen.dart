import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@RoutePage()
class MediaCatalogPage extends StatelessWidget {
  const MediaCatalogPage({super.key});

  @override
  Widget build(BuildContext context) =>
      AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: context.colors.backgroundSurface3,
          appBar: BaladyTopBar.iconAndText(
            systemUiOverlayStyle: SystemUiOverlayStyle.dark,
            title: 'Media Catalog',
            colorEnabled: context.color.textAndIconsStatusAccent,
          ),
        ),
      );
}
