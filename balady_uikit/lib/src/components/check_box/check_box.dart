import 'package:balady_uikit/core/utils/constants.dart';
import 'package:balady_uikit/gen/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Use [BaladyCheckBox] class when you need to select multiple elements on the screen.
/// The class has 3 [BaladyCheckBoxState]
/// 1. [BaladyCheckBoxState.unchecked] is when your element is highlighted as "Not Selected"
/// 2. [BaladyCheckBoxState.indeterminate] - this is when your element is highlighted neutrally, used mainly when there is a tree structure of elements on the screen
/// 3. [BaladyCheckBoxState.checked] - shows that the element is selected
/// The state must be set immediately when calling the class constructor
///
/// See also:
/// * [Figma Design] (https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=3024-14014&mode=design&t=UqaM76nAele4Zb1n-0), design specs

enum BaladyCheckBoxState { unchecked, indeterminate, checked }

class BaladyCheckBox extends StatefulWidget {
  final BaladyCheckBoxState state;
  final Function(BaladyCheckBoxState state)? onChanged;
  final bool disable;

  const BaladyCheckBox({
    required this.state,
    required this.disable,
    Key? key,
    this.onChanged,
  }) : super(key: key);

  @override
  State<BaladyCheckBox> createState() => _BaladyCheckBoxState();
}

class _BaladyCheckBoxState extends State<BaladyCheckBox> {
  late ValueNotifier<BaladyCheckBoxState> _currentStateNotifier;
  late ValueNotifier<bool> _isPressedNotifier;
  late bool _isIndeterminate;

  @override
  void initState() {
    _isIndeterminate = widget.state == BaladyCheckBoxState.indeterminate;
    _currentStateNotifier = ValueNotifier<BaladyCheckBoxState>(widget.state);
    _isPressedNotifier = ValueNotifier<bool>(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabledAndOnChanged = !widget.disable && widget.onChanged != null;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) {
        if (isEnabledAndOnChanged) {
          _isPressedNotifier.value = true;
          setState(() {});
        }
      },
      onTapUp: (_) {
        if (isEnabledAndOnChanged) {
          _isPressedNotifier.value = false;
          setState(() {});
          _updateState();
          if (widget.onChanged != null) {
            widget.onChanged!(_currentStateNotifier.value);
          }
        }
      },
      onTapCancel: () {
        if (isEnabledAndOnChanged) {
          _isPressedNotifier.value = false;
          setState(() {});
        }
      },
      child: ValueListenableBuilder<BaladyCheckBoxState>(
        valueListenable: _currentStateNotifier,
        builder: (context, state, child) => _buildBox(state),
      ),
    );
  }

  void _updateState() {
    const values = BaladyCheckBoxState.values;
    final current = _currentStateNotifier.value;
    int newIndex = current.index;
    if (_isIndeterminate) {
      newIndex = (current.index - 1) % values.length;
    } else {
      newIndex = current.index == 0 ? 2 : 0;
    }
    _currentStateNotifier.value = values[newIndex];
  }

  Widget _buildBox(BaladyCheckBoxState state) {
    switch (state) {
      case BaladyCheckBoxState.unchecked:
        return SvgPicture.asset(
          _isPressedNotifier.value
              ? Assets.icons.icCheckBoxUnselectedPressed.path
              : (widget.disable
                  ? Assets.icons.icCheckBoxUnselectedDisable.path
                  : Assets.icons.icCheckBoxUnselectedEnable.path),
          package: packageName,
        );
      case BaladyCheckBoxState.checked:
        return SvgPicture.asset(
          _isPressedNotifier.value
              ? Assets.icons.icCheckBoxSelectedPressed.path
              : (widget.disable
                  ? Assets.icons.icCheckBoxSelectedDisable.path
                  : Assets.icons.icCheckBoxSelectedEnable.path),
          package: packageName,
        );
      case BaladyCheckBoxState.indeterminate:
        return SvgPicture.asset(
          _isPressedNotifier.value
              ? Assets.icons.icCheckBoxIndeterminatePressed.path
              : (widget.disable
                  ? Assets.icons.icCheckBoxIndeterminateDisable.path
                  : Assets.icons.icCheckBoxIndeterminateEnable.path),
          package: packageName,
        );
    }
  }

  @override
  void dispose() {
    _currentStateNotifier.dispose();
    _isPressedNotifier.dispose();
    super.dispose();
  }
}
