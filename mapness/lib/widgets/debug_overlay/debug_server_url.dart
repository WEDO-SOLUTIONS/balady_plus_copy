import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/config/environment_config.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

class DebugServerUrl extends ConsumerWidget {
  const DebugServerUrl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envConfigAsync = ref.watch(dgisEnvironmentProvider);
    final envTypeAsync = ref.watch(dgisEnvTypeProvider);

    // Wait for both providers to load
    if (envConfigAsync.isLoading || envTypeAsync.isLoading) {
      return const SizedBox.shrink();
    }
    if (envConfigAsync.hasError || envTypeAsync.hasError) {
      return const SizedBox.shrink();
    }

    final envConfig = envConfigAsync.value!;
    final currentEnvType = envTypeAsync.value!;

    return DebugCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DebugSectionHeader(
            icon: Icons.dns_rounded,
            title: 'Server Environment',
            subtitle: 'Switch API endpoints',
            gradient: DebugTheme.gradientBlue,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: DebugTheme.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.link_rounded,
                  size: 14,
                  color: DebugTheme.textMuted,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    envConfig.url,
                    style: context.textStyles.captionSmallMedium.copyWith(
                      color: DebugTheme.textSecondary,
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _EnvButton(
                label: 'Urbi Dev',
                isActive: currentEnvType == DgisEnv.urbiDev,
                onPressed: () => ref.read(dgisEnvironmentProvider.notifier).setEnv(DgisEnv.urbiDev),
              ),
              _EnvButton(
                label: 'Urbi Pre',
                isActive: currentEnvType == DgisEnv.urbiPreprod,
                onPressed: () => ref.read(dgisEnvironmentProvider.notifier).setEnv(DgisEnv.urbiPreprod),
              ),
              _EnvButton(
                label: 'Momrah Stg',
                isActive: currentEnvType == DgisEnv.momrahStaging,
                onPressed: () => ref.read(dgisEnvironmentProvider.notifier).setEnv(DgisEnv.momrahStaging),
              ),
              _EnvButton(
                label: 'Momrah Prod',
                isActive: currentEnvType == DgisEnv.momrahProd,
                onPressed: () => ref.read(dgisEnvironmentProvider.notifier).setEnv(DgisEnv.momrahProd),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EnvButton extends StatelessWidget {
  const _EnvButton({
    required this.label,
    required this.isActive,
    required this.onPressed,
  });

  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onPressed,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: isActive ? DebugTheme.gradientBlue : null,
        color: isActive ? null : DebugTheme.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? Colors.transparent : DebugTheme.border,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: DebugTheme.info.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Text(
        label,
        style: context.textStyles.captionSmallMedium.copyWith(
          color: isActive ? Colors.white : DebugTheme.textSecondary,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    ),
  );
}
