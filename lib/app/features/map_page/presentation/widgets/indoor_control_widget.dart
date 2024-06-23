import 'package:balady_plus/app/features/map_page/data/model/states.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

const _indoorItemSize = 38.0;
const _shadowHeight = 12.0;

class IndoorControl extends StatelessWidget {
  const IndoorControl({
    required this.indoorState,
    required this.onLevelTaped,
    super.key,
  });

  final ValueListenable<IndoorState> indoorState;
  final Function(IndoorLevel) onLevelTaped;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<IndoorState>(
      valueListenable: indoorState,
      builder: (_, state, __) {
        final levelNames = state.levelNames;
        final activeIndex = state.activeIndex;

        final hasLevels =
            levelNames != null && activeIndex != null && levelNames.isNotEmpty;

        return AnimatedCrossFade(
          firstChild: SizedBox(
            height: _indoorItemSize * 3,
            width: _indoorItemSize,
            child: hasLevels
                ? _LevelsControl(
                    levelNames: levelNames,
                    activeIndex: activeIndex,
                    onLevelTaped: onLevelTaped,
                  )
                : null,
          ),
          secondChild: const SizedBox(
            height: _indoorItemSize * 3,
            width: _indoorItemSize,
          ),
          crossFadeState: state.hasLevels
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300),
        );
      },
    );
  }
}

class _Gradient extends StatelessWidget {
  const _Gradient({
    super.key,
    this.bottomToTop = false,
  });

  final bool bottomToTop;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _shadowHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: bottomToTop ? Alignment.bottomCenter : Alignment.topCenter,
          end: bottomToTop ? Alignment.topCenter : Alignment.bottomCenter,
          colors: const [Colors.black12, Colors.transparent],
        ),
      ),
    );
  }
}

class _LevelsControl extends StatefulWidget {
  const _LevelsControl({
    required this.levelNames,
    required this.activeIndex,
    required this.onLevelTaped,
    super.key,
  });

  final List<IndoorLevel> levelNames;
  final int activeIndex;
  final Function(IndoorLevel level) onLevelTaped;

  @override
  State<_LevelsControl> createState() => _LevelsControlState();
}

class _LevelsControlState extends State<_LevelsControl> {
  final scrollController = ScrollController();

  var hideTopShadow = true;
  var hideBottomShadow = true;

  // Used to hide initial scroll animation
  var initialScrollDone = false;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      setState(() {
        hideBottomShadow = scrollController.offset == 0;
        hideTopShadow =
            scrollController.position.atEdge && (scrollController.offset != 0);
      });
    });

    // Waiting first frame to be drawn and scrolling to active list item
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await scrollController.position.animateTo(
        widget.levelNames[widget.activeIndex].levelIndex * _indoorItemSize,
        // Cannot be set to zero, so leaving small duration
        duration: const Duration(milliseconds: 16),
        curve: Curves.linear,
      );
      setState(() => initialScrollDone = true);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 100),
      opacity: initialScrollDone ? 1.0 : 0.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            const Positioned.fill(
              child: ColoredBox(color: Colors.white),
            ),
            ListView.separated(
              reverse: true,
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              controller: scrollController,
              itemCount: widget.levelNames.length,
              itemBuilder: (_, index) => GestureDetector(
                onTap: () => widget.onLevelTaped(widget.levelNames[index]),
                child: Container(
                  width: _indoorItemSize,
                  height: _indoorItemSize,
                  color:
                      index == widget.levelNames[widget.activeIndex].levelIndex
                          ? Colors.lightBlueAccent
                          : Colors.white,
                  padding: const EdgeInsets.all(4),
                  child: Center(
                    child: Text(widget.levelNames[index].name),
                  ),
                ),
              ),
              separatorBuilder: (_, __) => const Divider(
                height: 1.0,
                color: Color(0xffdadada),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: hideTopShadow ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: const _Gradient(),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: hideBottomShadow ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: const _Gradient(bottomToTop: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
