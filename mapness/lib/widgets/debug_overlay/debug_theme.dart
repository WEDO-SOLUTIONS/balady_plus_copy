import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Design tokens for the debug overlay
class DebugTheme {
  DebugTheme._();

  // Background colors
  static const background = Color(0xFF0D0D0F);
  static const surface = Color(0xFF18181B);
  static const surfaceLight = Color(0xFF27272A);
  static const surfaceHighlight = Color(0xFF323238);

  // Border colors
  static const border = Color(0xFF3F3F46);
  static const borderLight = Color(0xFF52525B);

  // Text colors
  static const textPrimary = Color(0xFFFAFAFA);
  static const textSecondary = Color(0xFFA1A1AA);
  static const textMuted = Color(0xFF71717A);

  // Accent colors
  static const accent = Color(0xFF8B5CF6);
  static const accentLight = Color(0xFFA78BFA);
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const info = Color(0xFF3B82F6);

  // Gradients
  static const gradientPurple = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
  );
  static const gradientGreen = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF10B981)],
  );
  static const gradientAmber = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
  );
  static const gradientTeal = LinearGradient(
    colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
  );
  static const gradientBlue = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
  );
  static const gradientRed = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
  );
  static const gradientPink = LinearGradient(
    colors: [Color(0xFFEC4899), Color(0xFFDB2777)],
  );
}

/// A card component for debug sections
class DebugCard extends StatelessWidget {
  const DebugCard({
    required this.child,
    this.padding = const EdgeInsets.all(14),
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: DebugTheme.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: DebugTheme.border),
    ),
    child: Padding(
      padding: padding,
      child: child,
    ),
  );
}

/// Section header with icon and title
class DebugSectionHeader extends StatelessWidget {
  const DebugSectionHeader({
    required this.icon,
    required this.title,
    this.subtitle,
    this.gradient = DebugTheme.gradientPurple,
    this.trailing,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Gradient gradient;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: context.textStyles.bodySmallSemiBold.copyWith(
                color: DebugTheme.textPrimary,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: context.textStyles.captionSmallRegular.copyWith(
                  color: DebugTheme.textMuted,
                ),
              ),
          ],
        ),
      ),
      if (trailing != null) trailing!,
    ],
  );
}

/// A fancy toggle switch
class DebugSwitch extends StatelessWidget {
  const DebugSwitch({
    required this.value,
    required this.onChanged,
    this.gradient = DebugTheme.gradientPurple,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => onChanged(!value),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 44,
      height: 24,
      decoration: BoxDecoration(
        gradient: value ? gradient : null,
        color: value ? null : DebugTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? Colors.transparent : DebugTheme.border,
        ),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 200),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.all(2),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// A toggle row with label and switch
class DebugToggleRow extends StatelessWidget {
  const DebugToggleRow({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.gradient = DebugTheme.gradientPurple,
    super.key,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Container(
          width: 3,
          height: 32,
          decoration: BoxDecoration(
            gradient: value ? gradient : null,
            color: value ? null : DebugTheme.border,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textStyles.bodySmallMedium.copyWith(
                  color: value ? DebugTheme.textPrimary : DebugTheme.textSecondary,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: context.textStyles.captionSmallRegular.copyWith(
                    color: DebugTheme.textMuted,
                  ),
                ),
            ],
          ),
        ),
        DebugSwitch(
          value: value,
          onChanged: onChanged,
          gradient: gradient,
        ),
      ],
    ),
  );
}

/// A gradient button
class DebugButton extends StatelessWidget {
  const DebugButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.gradient = DebugTheme.gradientPurple,
    this.isCompact = false,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Gradient gradient;
  final bool isCompact;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onPressed,
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 12 : 16,
        vertical: isCompact ? 8 : 12,
      ),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: isCompact ? MainAxisSize.min : MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: isCompact ? 14 : 18),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: context.textStyles.bodySmallSemiBold.copyWith(
              color: Colors.white,
              fontSize: isCompact ? 12 : 14,
            ),
          ),
        ],
      ),
    ),
  );
}

/// An outlined button
class DebugOutlinedButton extends StatelessWidget {
  const DebugOutlinedButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = DebugTheme.textSecondary,
    this.isCompact = false,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color color;
  final bool isCompact;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onPressed,
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 10 : 14,
        vertical: isCompact ? 6 : 10,
      ),
      decoration: BoxDecoration(
        color: DebugTheme.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: DebugTheme.border),
      ),
      child: Row(
        mainAxisSize: isCompact ? MainAxisSize.min : MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: isCompact ? 12 : 16),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: context.textStyles.captionSmallMedium.copyWith(
              color: color,
              fontSize: isCompact ? 11 : 13,
            ),
          ),
        ],
      ),
    ),
  );
}

/// Info row with label and value
class DebugInfoRow extends StatelessWidget {
  const DebugInfoRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.onCopy,
    super.key,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: context.textStyles.captionSmallRegular.copyWith(
              color: DebugTheme.textMuted,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: context.textStyles.captionSmallMedium.copyWith(
              color: valueColor ?? DebugTheme.textPrimary,
            ),
          ),
        ),
        if (onCopy != null)
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));
              onCopy?.call();
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.copy_rounded,
                size: 14,
                color: DebugTheme.textMuted,
              ),
            ),
          ),
      ],
    ),
  );
}

/// Badge/Chip component
class DebugBadge extends StatelessWidget {
  const DebugBadge({
    required this.label,
    this.color = DebugTheme.accent,
    this.isActive = true,
    super.key,
  });

  final String label;
  final Color color;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = isActive ? color : DebugTheme.textMuted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: effectiveColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: effectiveColor.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: context.textStyles.captionSmallMedium.copyWith(
          color: effectiveColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Status indicator dot
class DebugStatusDot extends StatelessWidget {
  const DebugStatusDot({
    required this.isActive,
    this.activeColor = DebugTheme.success,
    this.size = 8,
    super.key,
  });

  final bool isActive;
  final Color activeColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? activeColor : DebugTheme.textMuted;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 4,
                ),
              ]
            : null,
      ),
    );
  }
}

/// Divider
class DebugDivider extends StatelessWidget {
  const DebugDivider({super.key});

  @override
  Widget build(BuildContext context) => Container(
    height: 1,
    margin: const EdgeInsets.symmetric(vertical: 12),
    color: DebugTheme.border,
  );
}

/// Text field
class DebugTextField extends StatelessWidget {
  const DebugTextField({
    required this.controller,
    this.hint,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String? hint;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    style: context.textStyles.bodySmallRegular.copyWith(
      color: DebugTheme.textPrimary,
    ),
    onSubmitted: onSubmitted,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: context.textStyles.bodySmallRegular.copyWith(
        color: DebugTheme.textMuted,
      ),
      filled: true,
      fillColor: DebugTheme.surfaceLight,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: DebugTheme.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: DebugTheme.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: DebugTheme.accent),
      ),
    ),
  );
}
