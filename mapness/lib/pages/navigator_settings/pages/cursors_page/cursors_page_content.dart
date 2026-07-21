import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/features/navigation_cursor/navigation_cursor.dart';
import 'package:mapness/features/navigation_cursor/navigation_cursor_controller.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:urbi_utils/urbi_utils.dart';

class CursorsPageContent extends ConsumerWidget {
  const CursorsPageContent({super.key, this.scrollable = true});

  /// `false` when embedded into an outer scrollable (the ToggleSheet in
  /// cursors_sheet.dart provides its own SliverList; a nested scroll view
  /// would swallow the sheet's drag gestures).
  final bool scrollable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final cardColor = context.profileCardColor;
    final data = ref.watch(navigationCursorControllerProvider);
    final controller = ref.read(navigationCursorControllerProvider.notifier);

    ref.listen(navigationCursorControllerProvider, (previous, next) {
      final error = next.lastError;
      final wasError = previous?.lastError;
      if (error != null && error != wasError) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('$error')));
        controller.clearError();
      }
    });

    final yourCursors = NavigationCursor.values.where(data.isDownloaded).toList();
    final available = NavigationCursor.values.where((c) => !data.isDownloaded(c)).toList();

    // BALADY-3762: section headers are h4SemiBold with the subtitle under
    // "Your cursors", and the list keeps a full bottom padding (Figma
    // 2287-3295) — not the uikit ContentColumn caption-label layout.
    final body = Padding(
      padding: const EdgeInsets.all(Spacing.$4x),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _SectionHeader(text: l10n.yourCursors),
          const SizedBox(height: Spacing.$0_5x),
          _SubtitleRow(text: l10n.selectNavigatorType),
          const SizedBox(height: Spacing.$4x),
          ContentWrapper(
            color: cardColor,
            children: [
              for (final cursor in yourCursors)
                _CursorRow(
                  cursor: cursor,
                  trailing: cursor == data.active ? _CursorTrailing.selected : _CursorTrailing.pickable,
                  busy: data.inProgress == cursor,
                  onTap: cursor == data.active ? null : () => controller.select(cursor),
                  onLongPress: cursor.requiresDownload ? () => _dropLocal(context, controller, cursor) : null,
                ),
            ],
          ),
          if (available.isNotEmpty) ...[
            const SizedBox(height: Spacing.$3x),
            _SectionHeader(text: l10n.cursorsAvailable),
            const SizedBox(height: Spacing.$4x),
            ContentWrapper(
              color: cardColor,
              children: [
                for (final cursor in available)
                  _CursorRow(
                    cursor: cursor,
                    trailing: _CursorTrailing.downloadable,
                    busy: data.inProgress == cursor,
                    onTap: () => controller.select(cursor),
                    onLongPress: cursor.requiresDownload ? () => _dropLocal(context, controller, cursor) : null,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
    if (!scrollable) {
      // Sheet mode: the ToggleSheet already constrains the width in
      // landscape (see cursors_sheet.dart).
      return body;
    }
    // BALADY-3763: full-page mode — cap the content width so landscape does
    // not stretch rows across the whole screen, pushing trailing icons to
    // the far edge.
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxContentWidth),
          child: body,
        ),
      ),
    );
  }

  static const _maxContentWidth = 600.0;
}

enum _CursorTrailing { selected, pickable, downloadable }

// TEMP debug: dispatched from _CursorRow.onLongPress. Delete the cached
// GLB via the controller and confirm via snackbar. Safe to remove once
// CDN rotation flow (rename in enum + release) is in place.
Future<void> _dropLocal(
  BuildContext context,
  NavigationCursorController controller,
  NavigationCursor cursor,
) async {
  final deleted = await controller.deleteLocal(cursor);
  if (!context.mounted) {
    return;
  }
  final label = cursor.title(context);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(deleted ? '$label: cache cleared' : '$label: nothing cached')),
    );
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
  );
}

class _SubtitleRow extends StatelessWidget {
  const _SubtitleRow({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
  );
}

class _CursorRow extends StatelessWidget {
  const _CursorRow({
    required this.cursor,
    required this.trailing,
    required this.busy,
    required this.onTap,
    this.onLongPress,
  });

  final NavigationCursor cursor;
  final _CursorTrailing trailing;
  final bool busy;
  final VoidCallback? onTap;
  // TEMP debug: long-press drops the cached GLB from disk so the next tap
  // re-downloads from CDN. Remove alongside the corresponding controller /
  // downloader methods when the CDN model rotation flow stabilises.
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final options = ContentRowOptions(
      title: cursor.title(context),
      titleStyle: context.textStyle.text.copyWith(color: colors.foregroundDefault),
      leadingIcon: _CursorThumbnail(cursor: cursor),
      dividerEnabled: true,
      // Every trailing state goes through `customActionWidget` (Widget?) so
      // the design-team SVGs for checkmark and download render as-is,
      // without shoehorning them into balady_uikit's IconData-only
      // `ContentRowActionOptions.actionIcon`.
      customActionWidget: _trailing(),
    );
    final row = ContentRow(onTap: busy ? null : onTap, options: options);
    if (busy || onLongPress == null) {
      return row;
    }
    // Wrap in a transparent GestureDetector layered ABOVE the ContentRow.
    // HitTestBehavior.opaque swallows the long-press so ContentRow's own
    // InkWell doesn't fire onTap alongside; short taps still reach it
    // because our detector only listens to onLongPress.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: onLongPress,
      child: row,
    );
  }

  Widget? _trailing() {
    if (busy) {
      return const _RowSpinner();
    }
    switch (trailing) {
      case _CursorTrailing.selected:
        return const _TrailingSvg(asset: 'assets/icons/cursors/ic_checkmark.svg');
      case _CursorTrailing.pickable:
        // Downloaded but not active — no trailing icon, whole row is tappable.
        return null;
      case _CursorTrailing.downloadable:
        return const _TrailingSvg(asset: 'assets/icons/cursors/ic_download.svg');
    }
  }
}

class _TrailingSvg extends StatelessWidget {
  const _TrailingSvg({required this.asset});
  final String asset;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: Spacing.$4x),
    child: SvgPicture.asset(asset, width: 24, height: 24),
  );
}

class _RowSpinner extends StatelessWidget {
  const _RowSpinner();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.only(right: Spacing.$4x),
    child: SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(strokeWidth: 2),
    ),
  );
}

/// Cursor thumbnail. Prefers the real PNG under
/// `assets/icons/cursors/thumb_*.png`; falls back to a tinted square keyed
/// by [NavigationCursor.index] so each row still reads distinctly if the
/// asset is missing (e.g. during asset pipeline hiccups).
class _CursorThumbnail extends StatelessWidget {
  const _CursorThumbnail({required this.cursor});
  final NavigationCursor cursor;

  static const _size = 32.0;
  static const _palette = <Color>[
    Color(0xFFF6BC00),
    Color(0xFFE07A5F),
    Color(0xFF81B29A),
    Color(0xFF3D5A80),
    Color(0xFF9D4EDD),
    Color(0xFF2A9D8F),
    Color(0xFFE76F51),
    Color(0xFF264653),
  ];

  @override
  Widget build(BuildContext context) => SizedBox(
    width: _size,
    height: _size,
    child: Image.asset(
      cursor.thumbnailAsset,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => _fallback(),
    ),
  );

  Widget _fallback() {
    final color = _palette[cursor.index % _palette.length];
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
