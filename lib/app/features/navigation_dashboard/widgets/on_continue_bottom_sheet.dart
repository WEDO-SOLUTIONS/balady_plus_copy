part of '../dashboard_control.dart';

///
const HIDDEN_STATE = 0.0;

///
const VISIBLE_STATE = 1.0;

///
class OnContinueBottomSheet extends StatefulWidget {
  ///
  const OnContinueBottomSheet({
    super.key,
    this.onPressed,
  });

  final void Function()? onPressed;

  @override
  State<OnContinueBottomSheet> createState() => OnContinueBottomSheetState();
}

///
class OnContinueBottomSheetState extends State<OnContinueBottomSheet>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    value: 0.0,
    duration: const Duration(milliseconds: 100),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.ease,
  );

  ///
  Future<void> hide() async {
    await _controller.animateTo(HIDDEN_STATE);
  }

  ///
  Future<void> expand() async {
    await _controller.animateTo(VISIBLE_STATE);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _animation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: InkWell(
            onTap: widget.onPressed,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(4.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Continue Ride\n',
                  style: MapnessTypography.l.copyWith(color: Colors.white),
                  children: <TextSpan>[
                    TextSpan(
                      text: '900m \t  11:57AM',
                      style: MapnessTypography.m.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
