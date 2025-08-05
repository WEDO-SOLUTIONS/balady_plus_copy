import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';

class PoiContentAccessabilityCard extends StatelessWidget {
  final PoiContentAccessibilityModel data;
  const PoiContentAccessabilityCard({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final deliveryAvailableIcon = isRtl ? TransportIcons.truckRTL : TransportIcons.truckLTR;
    return ContentWrapper(
      color: context.color.surfaceBasePrimary,
      children: [
        if (data.deliveryAvailableTitle != null)
          _AccessibilityInfoItem(
            title: data.deliveryAvailableTitle!,
            iconData: deliveryAvailableIcon,
          ),
        if (data.serveDisablePersonsTitle != null)
          _AccessibilityInfoItem(
            title: data.serveDisablePersonsTitle!,
            iconData: GeneralIcons.accessibilityWheels,
          ),
      ],
    );
  }
}

class _AccessibilityInfoItem extends StatelessWidget {
  final String title;
  final IconData iconData;

  const _AccessibilityInfoItem({required this.title, required this.iconData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ContentRow(
        leading: iconData.icon(
          color: context.colors.accentDefault,
        ),
        text: ContentRowTextOptions(
          title: title,
        ),
      );
}
