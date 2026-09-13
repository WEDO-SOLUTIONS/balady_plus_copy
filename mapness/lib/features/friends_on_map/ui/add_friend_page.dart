import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/invite_card.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/scan_qr_view.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

enum _AddFriendTab { myCode, scan }

/// S-07: "link and QR share one entry screen" (BRD Appendix E.2), matching
/// AC-01's "choose the link route" vs "choose the code route". [_AddFriendTab.scan]
/// is only built while selected — not both eagerly — so `ScanQrView`'s
/// camera permission request/controller only fires once the user actually
/// switches to it, and tears down when they switch away or leave the page.
@RoutePage()
class AddFriendPage extends ConsumerStatefulWidget {
  const AddFriendPage({super.key});

  @override
  ConsumerState<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends ConsumerState<AddFriendPage> {
  _AddFriendTab _tab = _AddFriendTab.myCode;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: ref.watch(uiDirectionProvider),
    child: Material(
      color: context.colors.backgroundSurface4,
      child: Scaffold(
        appBar: BaladyTopBar.iconAndText(
          title: context.l10n.addFriendTitle,
          colorEnabled: context.colors.accentDefault,
          leading: ActionModel(onPressed: () => context.router.pop(), icon: SystemIcons.arrowCornerLeftLarge),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.$4x),
            child: Column(
              children: [
                _TabSwitcher(
                  value: _tab,
                  onChanged: (tab) => setState(() => _tab = tab),
                ),
                const SizedBox(height: Spacing.$4x),
                Expanded(child: _tab == _AddFriendTab.myCode ? const _MyCodeTab() : const ScanQrView()),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _TabSwitcher extends StatelessWidget {
  final _AddFriendTab value;
  final ValueChanged<_AddFriendTab> onChanged;

  const _TabSwitcher({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: _TabButton(
          label: context.l10n.addFriendMyCodeTab,
          selected: value == _AddFriendTab.myCode,
          onTap: () => onChanged(_AddFriendTab.myCode),
        ),
      ),
      const SizedBox(width: Spacing.$2x),
      Expanded(
        child: _TabButton(
          label: context.l10n.addFriendScanTab,
          selected: value == _AddFriendTab.scan,
          onTap: () => onChanged(_AddFriendTab.scan),
        ),
      ),
    ],
  );
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => AppButton(
    buttonColorScheme: ButtonColorScheme.accentSecondary,
    buttonType: selected ? ButtonType.primary : ButtonType.secondary,
    primaryLabel: label,
    onTap: onTap,
  );
}

class _MyCodeTab extends StatelessWidget {
  const _MyCodeTab();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      children: [
        Text(
          context.l10n.addFriendShareNote,
          textAlign: TextAlign.center,
          style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundMuted),
        ),
        const SizedBox(height: Spacing.$4x),
        const InviteCard(),
      ],
    ),
  );
}
