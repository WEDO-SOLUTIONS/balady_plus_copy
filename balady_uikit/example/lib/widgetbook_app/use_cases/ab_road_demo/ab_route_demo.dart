import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: '19. ABRoute',
  type: Widget,
)
Widget abRouteDemo(BuildContext context) {
  final size = context.knobs.double.slider(label: 'Size Overlap', initialValue: 351, min: 200, max: 800, divisions: 10);

  final items = [
    const ABRouteModel(title: 'My Location', isMyLocation: true),
    const ABRouteModel(title: 'B point', isMyLocation: false),
    const ABRouteModel(title: 'C point', isMyLocation: false),
  ];

  return SizedBox(
    width: size,
    child: ExampleAandBRoute(items: items),
  );
}

class ExampleAandBRoute extends StatefulWidget {
  final List<ABRouteModel> items;

  const ExampleAandBRoute({required this.items, super.key});

  @override
  State<ExampleAandBRoute> createState() => _ExampleAandBRouteState();
}

class _ExampleAandBRouteState extends State<ExampleAandBRoute> {
  @override
  Widget build(BuildContext context) {
    var isLTR = Directionality.of(context) == TextDirection.ltr;
    return ABRoute(
      items: widget.items,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final ABRouteModel item = widget.items.removeAt(oldIndex);
          widget.items.insert(newIndex, item);
        });
      },
      onTap: (index) {},
      startPointSubtitle: isLTR ? 'Start position' : 'وضع البداية',
      arrivalPointSubtitle: isLTR ? 'Place of arrival' : 'مكان الوصول',
    );
  }
}
