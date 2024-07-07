part of '../poi_card_footer.dart';

class _Wrapper extends StatelessWidget {
  final List<Widget> children;
  const _Wrapper({
    required this.children,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.all(PoiCardFooter.padding),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: PoiCardFooter.height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: children,
            ),
          ),
        ),
      );
}
