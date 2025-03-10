import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/pages/navigator_settings/components/voice_row_widget.dart';
import 'package:mapness/shared/providers/map/sound_settings.dart';
import 'package:urbi_utils/urbi_utils.dart';

class VoicePageContent extends ConsumerStatefulWidget {
  const VoicePageContent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VoicePageContentState();
}

class _VoicePageContentState extends ConsumerState<VoicePageContent> {
  int _currentSegment = 0;

  void onValueChanged(int? newValue) {
    setState(() {
      _currentSegment = newValue!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final soundSettingsModel = ref.watch(soundSettingsProvider);

    final voicesEnglish = soundSettingsModel.englishInstalledVoices + soundSettingsModel.englishUnInstalledVoices;
    final voicesArabic = soundSettingsModel.arabicInstalledVoices + soundSettingsModel.arabicUnInstalledVoices;

    final colorsV2 = context.colorsV2;

    // This text does not require translation.
    final children = <int, Widget>{
      0: const Text('العربية'),
      1: const Text('English'),
    };

    return Padding(
      padding: const EdgeInsets.all(Spacing.$4x).copyWith(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: 32,
            child: CupertinoSlidingSegmentedControl<int>(
              children: children,
              onValueChanged: onValueChanged,
              groupValue: _currentSegment,
            ),
          ),
          ContentWrapper(
            color: colorsV2.backgroundSurface1,
            children: (_currentSegment == 0 ? voicesArabic : voicesEnglish)
                .map<Widget>((e) => VoiceRowWidget(package: e))
                .insertBetween(
                  Divider(
                    height: 0.5,
                    color: colorsV2.borderSoft,
                    thickness: 1,
                    indent: Spacing.$4x,
                    endIndent: 0,
                  ),
                )
                .toList(),
          ),
        ].insertBetween(Spacing.$4x.heightBox).toList(),
      ),
    );
  }
}
