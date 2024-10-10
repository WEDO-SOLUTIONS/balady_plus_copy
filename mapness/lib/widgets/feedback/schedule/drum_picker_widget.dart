import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

class DrumPickerWidget<T> extends StatefulWidget {
  final IList<T> items;
  final Widget Function(BuildContext, T) itemBuilder;
  final Widget Function(BuildContext, T)? selectedItemBuilder;
  final double itemHeight;
  final ValueChanged<T> onChanged;
  final int initialItem;

  const DrumPickerWidget({
    required this.items,
    required this.itemBuilder,
    required this.onChanged,
    Key? key,
    this.selectedItemBuilder,
    this.itemHeight = 50.0,
    this.initialItem = 0,
  }) : super(key: key);

  @override
  State<DrumPickerWidget<T>> createState() => _DrumPickerWidgetState<T>();
}

class _DrumPickerWidgetState<T> extends State<DrumPickerWidget<T>> {
  late FixedExtentScrollController _scrollController;
  late int _middleIndex;
  late int _selectedItem;

  @override
  void initState() {
    super.initState();
    // looped. Since builder used, no load
    _middleIndex = 10000 * widget.items.length;
    _selectedItem = widget.initialItem;
    _scrollController = FixedExtentScrollController(
      initialItem: _middleIndex + widget.initialItem,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListWheelScrollView.useDelegate(
        controller: _scrollController,
        itemExtent: widget.itemHeight,
        perspective: 0.001, // make it flat
        diameterRatio: 1000, // make it flat
        onSelectedItemChanged: (index) {
          setState(() {
            _selectedItem = index % widget.items.length;
          });
          widget.onChanged(widget.items[_selectedItem]);
        },
        physics: const FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            final itemIndex = index % widget.items.length;
            final item = widget.items[itemIndex];
            return _buildItem(itemIndex, item);
          },
        ),
      );

  Widget _buildItem(int itemIndex, T item) {
    final isSelected = itemIndex == _selectedItem;

    return SizedBox(
      height: widget.itemHeight,
      child: isSelected && widget.selectedItemBuilder != null
          ? widget.selectedItemBuilder!(context, item)
          : widget.itemBuilder(context, item),
    );
  }
}
