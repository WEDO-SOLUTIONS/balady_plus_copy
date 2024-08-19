part of '../poi_card_footer.dart';

class _Wrapper extends StatelessWidget {
  final List<Widget> children;
  const _Wrapper({
    required this.children,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              offset: const Offset(0, -1),
              blurRadius: 2,
            ),
          ],
        ),
        padding: const EdgeInsets.only(
          left: PoiCardFooter.padding,
          right: PoiCardFooter.padding,
          bottom: PoiCardFooter.padding,
          top: 12,
        ),
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
