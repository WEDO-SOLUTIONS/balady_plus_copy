import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/providers/uuid_provider.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/widgets/debug_overlay/better_route_settings_widget.dart';
import 'package:mapness/widgets/debug_overlay/cityscape_debug_switcher.dart';
import 'package:mapness/widgets/debug_overlay/debug_navigation_controll.dart';
import 'package:mapness/widgets/debug_overlay/debug_server_url.dart';
import 'package:mapness/widgets/debug_overlay/founding_day_debug_switcher.dart';
import 'package:mapness/widgets/debug_overlay/link_checker.dart';
import 'package:mapness/widgets/debug_overlay/onboarding_button.dart';
import 'package:mapness/widgets/debug_overlay/saudi_national_day_debug_switcher.dart';
import 'package:mapness/widgets/debug_overlay/slider_speed.dart';
import 'package:mapness/widgets/debug_overlay/sso_credential_view.dart';
import 'package:mapness/widgets/debug_overlay/voice_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DebugSheet extends ConsumerStatefulWidget {
  const DebugSheet({required DraggableScrollableController draggableController, super.key})
      : _draggableController = draggableController;

  final DraggableScrollableController _draggableController;

  @override
  ConsumerState<DebugSheet> createState() => _DebugSheetState();
}

class _DebugSheetState extends ConsumerState<DebugSheet> {
  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((packageInfo) {
      setState(() {
        _packageInfo = packageInfo;
      });
    });
  }

  PackageInfo? _packageInfo;

  @override
  Widget build(BuildContext context) => DraggableScrollableSheet(
        minChildSize: 0,
        maxChildSize: 0.9,
        initialChildSize: 0,
        snapSizes: const [0, 0.9],
        controller: widget._draggableController,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            color: Colors.white,
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              physics: const ClampingScrollPhysics(),
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('development-menu', style: context.textStyle.heading1.copyWith(color: Colors.black)),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Urbi Release Version: ',
                                  style: context.textStyle.footNote.copyWith(color: Colors.black54),
                                ),
                                TextSpan(
                                  text: PackageConfig.releaseVersion,
                                  style: context.textStyle.footNoteBold.copyWith(color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'App version: ',
                                  style: context.textStyle.footNote.copyWith(color: Colors.black54),
                                ),
                                TextSpan(
                                  text: '${_packageInfo?.version}(${_packageInfo?.buildNumber})',
                                  style: context.textStyle.footNoteBold.copyWith(color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                          // TODO(Sergei): temporary information for internal testing builds from AA branch
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Android Auto: ',
                                  style: context.textStyle.footNote.copyWith(color: Colors.black54),
                                ),
                                TextSpan(
                                  text: 'true',
                                  style: context.textStyle.footNoteBold.copyWith(color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'CI build version: \n',
                                  style: context.textStyle.footNote.copyWith(color: Colors.black54),
                                ),
                                TextSpan(
                                  text: PackageConfig.buildName,
                                  style: context.textStyle.footNoteBold.copyWith(color: Colors.black87, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      SvgPicture.asset(Assets.icons.svg.icBug.keyName, height: 30),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: Colors.black54),
                  ),
                  LabeledElevatedButton(
                    onPressed: () {
                      widget._draggableController.animateTo(
                        0.0,
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.linear,
                      );
                      logger.share();
                    },
                    label: 'Show logs',
                  ),
                  Text('Git branch:', style: context.textStyle.footNote.copyWith(color: Colors.black)),
                  Text(PackageConfig.gitBranch, style: context.textStyle.heading2.copyWith(color: Colors.black)),
                  const SizedBox(height: 16),
                  Text('Git commit:', style: context.textStyle.footNote.copyWith(color: Colors.black)),
                  Text(PackageConfig.gitCommit, style: context.textStyle.heading2.copyWith(color: Colors.black)),
                  const SizedBox(height: 16),
                  Text('Vendor:', style: context.textStyle.footNote.copyWith(color: Colors.black)),
                  Text(PackageConfig.vendorConfig, style: context.textStyle.heading2.copyWith(color: Colors.black)),
                  const SizedBox(height: 16),
                  Text('Uuid:', style: context.textStyle.footNote.copyWith(color: Colors.black)),
                  Text(
                    ref.watch(uuidProviderProvider),
                    style: context.textStyle.footNoteBold.copyWith(color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  LabeledElevatedButton(
                    onPressed: () => ref.read(uuidProviderProvider.notifier).randomize(),
                    label: 'randomize uuid',
                  ),
                  const DebugServerUrl(),
                  const SizedBox(height: 12),
                  const SsoCredentialView(),
                  const CityscapeDebugSwitcher(),
                  const SaudiNationalDayDebugSwitcher(),
                  const FoundingDayDebugSwitcher(),
                  const VoicePicker(),
                  const BetterRouteSettingsWidget(),
                  const SizedBox(height: 12),
                  const SliderSpeed(),
                  const SizedBox(height: 12),
                  const DebugNavigationControll(),
                  const ShowOnboardingButton(),
                  const ShowSaudiDayButton(),
                  const SizedBox(height: 12),
                  const LinkChecker(),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
          ),
        ),
      );
}
