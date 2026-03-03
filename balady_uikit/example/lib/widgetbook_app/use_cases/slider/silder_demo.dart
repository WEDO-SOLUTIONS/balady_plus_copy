import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: '21. Slider',
  type: Widget,
)
Widget sliderDemo(BuildContext context) {
  final width = context.knobs.double.slider(label: 'Viewport Width', min: 200, max: 500, initialValue: 375);
  final itemCount = context.knobs.int.input(label: 'Item count', initialValue: 10);
  final cardSize = context.knobs.double.slider(label: 'Card Size', min: 200, max: 500, initialValue: 300);
  final padding = context.knobs.double.slider(label: 'Padding', max: 64, initialValue: 16, divisions: 32);
  final separation = context.knobs.double.slider(label: 'Separation padding', max: 64, initialValue: 12, divisions: 32);
  final showCenterRectangle = context.knobs.boolean(label: 'Show Rectangle in Center');

  return ColoredBox(
    color: context.colors.foregroundMuted,
    child: Center(
      child: ColoredBox(
        color: Colors.white,
        child: SizedBox(
          height: cardSize + 60,
          width: width,
          child: SliderDemo(
            viewPortWidth: width,
            itemCount: itemCount,
            cardSize: cardSize,
            horizontalPadding: padding,
            separationWidth: separation,
            showCenterRectangle: showCenterRectangle,
          ),
        ),
      ),
    ),
  );
}

class SliderDemo extends StatelessWidget {
  final int itemCount;
  final double cardSize;
  final bool showCenterRectangle;
  final double horizontalPadding;
  final double separationWidth;
  final double? viewPortWidth;
  final void Function(ItemData item)? onTap;

  const SliderDemo({
    super.key,
    this.itemCount = 10,
    this.cardSize = 300,
    this.showCenterRectangle = true,
    this.horizontalPadding = Spacing.$4x,
    this.separationWidth = Spacing.$3x,
    this.viewPortWidth,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (showCenterRectangle)
          Center(
            child: Container(
              color: Colors.black.withOpacity(0.8),
              height: 350,
              width: cardSize,
              margin: const EdgeInsets.only(bottom: 8),
            ),
          ),
        Center(
          child: SliderListView(
            items: List.generate(itemCount, (index) {
              return ItemData('Item: ${index + 1}', HSLColor.fromAHSL(1, index / itemCount * 360, 0.9, 0.6).toColor());
            }),
            horizontalPadding: horizontalPadding,
            separationWidth: separationWidth,
            viewportWidth: viewPortWidth ?? MediaQuery.sizeOf(context).width,
            contentSize: cardSize,
            onTap: (item) {
              debugPrint(item.text);
              onTap?.call(item);
            },
            itemBuilder: (item) => ItemCard(item, cardSize, key: ValueKey(item?.text)),
          ),
        ),
      ],
    );
  }
}

class ItemData {
  final String text;
  final Color color;

  ItemData(this.text, this.color);
}

class ItemCard extends StatelessWidget {
  final ItemData? item;
  final double itemSize;

  const ItemCard(
    this.item,
    this.itemSize, {
    super.key,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(RadiusBorder.xl),
        child: Stack(
          children: [
            Container(
              height: itemSize,
              width: double.infinity,
              color: item?.color ?? Colors.black,
              child: Stack(
                children: [
                  ShaderMask(
                    blendMode: BlendMode.srcATop,
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [const Color(0x00000000), Colors.black.withOpacity(0.6)],
                    ).createShader(bounds),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(Spacing.$6x),
                      child: Text(
                        item?.text ?? '',
                        style: context.textStyles.h3SemiBold.copyWith(
                          color: context.colors.staticWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
