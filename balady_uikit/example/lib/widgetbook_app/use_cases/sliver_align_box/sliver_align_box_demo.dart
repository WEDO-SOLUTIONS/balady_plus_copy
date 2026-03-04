// ignore_for_file: avoid_print

import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Sliver Align Box Demo',
  type: Widget,
)
Widget sliverAlignBoxWork(BuildContext context) => const Align(
      alignment: Alignment.topLeft,
      child: ColoredBox(
        color: Colors.white,
        child: SliverAlignBoxDemo(),
      ),
    );

class SliverAlignBoxDemo extends StatelessWidget {
  const SliverAlignBoxDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAlignBox(
              alignment: Alignment.bottomRight,
              sliver: SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () {
                    print('Tap First Box');
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('First Box'),
                  ),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  print('Tap Second Box');
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Second Box'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
