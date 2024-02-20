import 'package:balady_uikit/components/content_row/content_row.dart';
import 'package:balady_uikit/gen/base.dart';
import 'package:flutter/material.dart';

import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'ContentRow',
  type: ContentRow,
)
ContentRow contentRowWork(BuildContext context) => ContentRow(
    icon1st: context.knobs.boolean(label: "Enable 1st icon")
        ? const Icon(Icons.ac_unit)
        : null,
    icon2nd: context.knobs.boolean(label: "Enable 2st icon")
        ? const Icon(Icons.ac_unit)
        : null,
    title: context.knobs.boolean(label: "Enable title")
        ? context.knobs.string(label: "Title input")
        : null,
    subtitle: context.knobs.boolean(label: "Enable subtitle")
        ? context.knobs.string(label: "Subtitle input")
        : null,
    subtitleExtra: context.knobs.boolean(label: "Enable subtitleExtra")
        ? context.knobs.string(label: "Subtitleextra input")
        : null,
    actionText: context.knobs.boolean(label: "Enable action text")
        ? context.knobs.string(label: "Action text input")
        : null,
    actionIcon: context.knobs.boolean(label: "Enable action icon")
        ? const Icon(Icons.ac_unit)
        : null,
  );
