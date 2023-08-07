import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';

class AboutBaladyScreen extends StatefulWidget {
  const AboutBaladyScreen({Key? key}) : super(key: key);

  @override
  State<AboutBaladyScreen> createState() => _AboutBaladyScreenState();
}

class _AboutBaladyScreenState extends State<AboutBaladyScreen> {
  late YoutubePlayerController _controller;
  String? videoId = YoutubePlayer.convertUrlToId(
      "https://www.youtube.com/watch?v=eJOuxpH2hBo");
  bool _isPlayerReady = false;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
      ),
    )..addListener(listener);
    super.initState();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: "about_balady".tr(),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          boxShadow: Constants.boxShadow,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: AppColor.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // youtube
            SizedBox(
              height: 175,
              child: YoutubePlayer(
                controller: _controller,
                bottomActions: [
                  CurrentPosition(),
                  ProgressBar(isExpanded: true),
                ],
              ),
            ),
            const CustomVerticalSpace(height: 20),
            CustomTextWidget(
              'about_balady_text'.tr(),
              fontColor: AppColor.blackModern500Light,
              fontWeight: AppFontWeight.bold,
              maxLines: null,
              fontSize: 14,
              height: 1.5,
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Icon(Icons.circle, size: 6),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: CustomTextWidget(
                    'about_balady_text2'.tr(),
                    fontColor: AppColor.blackModern500Light,
                    fontWeight: AppFontWeight.bold,
                    fontSize: 14,
                    maxLines: null,
                    height: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Icon(Icons.circle, size: 6),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: CustomTextWidget(
                    'about_balady_text3'.tr(),
                    fontColor: AppColor.blackModern500Light,
                    fontWeight: AppFontWeight.bold,
                    fontSize: 14,
                    maxLines: null,
                    height: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Icon(Icons.circle, size: 6),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: CustomTextWidget(
                    'about_balady_text4'.tr(),
                    fontColor: AppColor.blackModern500Light,
                    fontWeight: AppFontWeight.bold,
                    fontSize: 14,
                    maxLines: null,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
