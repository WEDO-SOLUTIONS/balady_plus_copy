import 'package:flutter/material.dart';
import 'package:mapness/features/friends_on_map/friend_marker_illustration.dart';

/// A plain circular avatar showing the friend's assigned illustration
/// (`friend_marker_illustration.dart`'s `illustrationAssetForFriend`) — the
/// same picture as their map marker, just without the marker's squircle
/// frame. Used in the friend list.
class FriendMarkerAvatar extends StatelessWidget {
  final String friendId;
  final double size;

  const FriendMarkerAvatar({required this.friendId, this.size = 42, super.key});

  @override
  Widget build(BuildContext context) => ClipOval(
    child: illustrationAssetForFriend(friendId).image(width: size, height: size, fit: BoxFit.cover),
  );
}
