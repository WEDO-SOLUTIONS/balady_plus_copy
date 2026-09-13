import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

/// Avatar (or initials fallback) shared by any row showing a friend or
/// friend-request identity — extracted once a second call site
/// (`friend_request_item.dart`) needed the exact same thing
/// `friend_list_item.dart` already had.
class FriendAvatar extends StatelessWidget {
  final String displayName;
  final String? profilePictureUrl;
  final double radius;

  const FriendAvatar({required this.displayName, this.profilePictureUrl, this.radius = 20, super.key});

  @override
  Widget build(BuildContext context) {
    final pictureUrl = profilePictureUrl;
    return CircleAvatar(
      radius: radius,
      backgroundColor: context.colors.accentSecondaryContainerDefault,
      backgroundImage: pictureUrl != null ? NetworkImage(pictureUrl) : null,
      child: pictureUrl == null
          ? Text(
              _initials(displayName),
              style: context.textStyles.bodySmallSemiBold.copyWith(color: context.colors.accentSecondaryOnContainer),
            )
          : null,
    );
  }

  // D-09 (BRD open decision): how initials are derived for a single-word
  // display name is a design decision, not settled here — first letter only
  // in that case, first letter of the first two words otherwise.
  String _initials(String name) {
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) {
      return '';
    }
    if (words.length == 1) {
      return words.first.substring(0, 1).toUpperCase();
    }
    return (words.first.substring(0, 1) + words[1].substring(0, 1)).toUpperCase();
  }
}
