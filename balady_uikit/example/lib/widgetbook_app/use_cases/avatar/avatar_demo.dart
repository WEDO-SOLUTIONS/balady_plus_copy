import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/gen/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

enum AvatarType {
  empty,
  url,
  asset,
  loading,
}

@widgetbook.UseCase(
  name: '3. Avatar',
  type: Widget,
)
Widget avatarDemo(BuildContext context) {
  final data = context.knobs.list(
    label: 'Type',
    options: AvatarType.values,
    initialOption: AvatarType.empty,
  );
  final style = context.knobs.list(
    label: 'Style for Empty Avatar',
    options: AvatarEmptyStyle.values,
    initialOption: AvatarEmptyStyle.accentSecondary,
  );
  final isGrayScale = context.knobs.boolean(label: 'Gray Scale');
  return Column(
    children: [
      Text(getText(data, style)),
      Row(
        children: AvatarSize.values
            .map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FutureBuilder<AvatarData>(
                  future: getAvatarData(data, style, isGrayScale),
                  builder: (context, snapshot) {
                    return Avatar(
                      size: e,
                      data: snapshot.data ?? const AvatarLoading(),
                    );
                  },
                ),
              ),
            )
            .toList(),
      ),
    ],
  );
}

String getText(AvatarType data, AvatarEmptyStyle style) {
  if (data == AvatarType.empty) {
    return 'Empty ($style)';
  } else if (data == AvatarType.url) {
    return 'Image (URL)';
  } else if (data == AvatarType.asset) {
    return 'Image (Asset)';
  }
  return 'Loading';
}

Future<AvatarData> getAvatarData(AvatarType data, AvatarEmptyStyle style, bool isGrayScale) async {
  if (data == AvatarType.empty) {
    return AvatarDataEmpty(style: style, isGrayScale: isGrayScale);
  } else if (data == AvatarType.url) {
    // This is a random image from the internet
    // I found it here https://docs.flutter.dev/cookbook/images/network-image
    return AvatarUrl('https://picsum.photos/250?image=9', isGrayScale: isGrayScale);
  } else if (data == AvatarType.asset) {
    return AvatarBytes(await _loadAssetBytes(Assets.images.imgTestStories.path), isGrayScale: isGrayScale);
  }
  return AvatarLoading(isGrayScale: isGrayScale);
}

Future<Uint8List> _loadAssetBytes(String assetPath) async {
  final bd = await rootBundle.load(assetPath);
  return bd.buffer.asUint8List();
}
