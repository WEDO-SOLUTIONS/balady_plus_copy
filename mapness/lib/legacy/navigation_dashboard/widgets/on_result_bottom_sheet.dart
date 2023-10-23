part of '../dashboard_control.dart';

///
const EXPANDED_STATE = 1.0;

/// @nodoc
class OnResultBottomSheet extends StatefulWidget {
  /// @nodoc
  const OnResultBottomSheet({
    super.key,
    required this.onFinishPressed,
    required this.onParkingPressed,
    required this.onMarkerPressed,
  });

  final void Function() onFinishPressed;
  final void Function() onParkingPressed;
  final void Function() onMarkerPressed;

  @override
  State<OnResultBottomSheet> createState() => OnResultBottomSheetState();
}

///
class OnResultBottomSheetState extends State<OnResultBottomSheet> {
  late final DraggableScrollableController _sheetController;
  late bool closable = true;

  ///
  Future<void> expand() async {
    await _sheetController.animateTo(
      EXPANDED_STATE,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  ///
  Future<void> hide() async {
    if (!closable) return;
    await _sheetController.animateTo(
      HIDDEN_STATE,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  void initState() {
    super.initState();
    _sheetController = DraggableScrollableController();
  }

  @override
  Widget build(BuildContext context) {
    print('closable=$closable');
    final _snapSizes = closable ? [0.0, 0.3] : [0.3];
    return DraggableScrollableSheet(
      snap: true,
      controller: _sheetController,
      initialChildSize: _snapSizes[0],
      minChildSize: _snapSizes[0],
      maxChildSize: 0.3,
      snapSizes: _snapSizes,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.white,
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const ClampingScrollPhysics(),
              controller: scrollController,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "You're here!",
                          style: MapnessTypography.l,
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                          child: IconButton(
                            onPressed: widget.onMarkerPressed,
                            icon: SvgPicture.asset(
                              'assets/icons/svg/routing/ic_arriving_point.svg',
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: widget.onParkingPressed,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Color(0xffF4F6F7),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.local_parking),
                            Text(
                              'Парковки',
                              style: MapnessTypography.m,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: widget.onFinishPressed,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        padding: const EdgeInsets.all(14.0),
                        child: const Center(
                          child: Text('Завершить поездку'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
