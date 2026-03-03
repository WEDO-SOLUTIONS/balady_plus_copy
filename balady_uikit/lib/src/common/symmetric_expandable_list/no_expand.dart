import 'package:balady_uikit/src/common/symmetric_expandable_list/sliver_symmetric_expandable_list.dart';
import 'package:balady_uikit/src/common/symmetric_expandable_list/symmetric_expandable_list.dart';
import 'package:flutter/material.dart';

/// A widget to wrap a child inside [SymmetricExpandableList] to disable inflating the size of this child.
class NoExpand extends ParentDataWidget<SymmetricExpandableParentData> {
  const NoExpand({required super.child, super.key, this.isExpanded = false});

  final bool isExpanded;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is SymmetricExpandableParentData,
        'Widget should contain [SymmetricExpandableParantData] parent data');

    (renderObject.parentData as SymmetricExpandableParentData?)?.isExpanded = isExpanded;

    final target = renderObject.parent;
    if (target is RenderObject) {
      target.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => SymmetricExpandableList;
}
