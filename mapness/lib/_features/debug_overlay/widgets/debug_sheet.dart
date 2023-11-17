import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/providers/uuid_provider.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DebugSheet extends ConsumerStatefulWidget {
  const DebugSheet({
    super.key,
    required DraggableScrollableController draggableController,
  }) : _draggableController = draggableController;

  final DraggableScrollableController _draggableController;

  @override
  ConsumerState<DebugSheet> createState() => _DebugSheetState();
}

class _DebugSheetState extends ConsumerState<DebugSheet> {
  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _packageInfo = packageInfo;
      });
    });
  }

  PackageInfo? _packageInfo;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0,
      maxChildSize: 0.5,
      initialChildSize: 0,
      controller: widget._draggableController,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            color: Colors.white,
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: SingleChildScrollView(
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
                          Text(
                            "development-menu",
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 19,
                              height: 1,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "App version: ",
                                  style: GoogleFonts.inter(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                    height: 1.3,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "${_packageInfo?.version}(${_packageInfo?.buildNumber})",
                                  style: GoogleFonts.inter(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    height: 1.3,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      SvgPicture.asset(
                        'assets/icons/svg/ic_bug.svg',
                        height: 30,
                        package: PackageConfig.packageName,
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    "Git branch:",
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    PackageConfig.gitBranch,
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Git commit:",
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    PackageConfig.gitCommit,
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Vendor:",
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    PackageConfig.vendorConfig,
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Uuid:",
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    ref.watch(uuidProviderProvider),
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LabeledElevatedButton(
                    onPressed: () =>
                        ref.read(uuidProviderProvider.notifier).randomize(),
                    label: 'randomize uuid',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
