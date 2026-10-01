import 'package:mapness/features/friends_on_map/data/chat_repository.dart';
import 'package:mapness/features/friends_on_map/data/remote_chat_repository.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_repository.g.dart';

@Riverpod(keepAlive: true)
ChatRepository chatRepository(Ref ref) => RemoteChatRepository(ref.watch(friendsOnMapNetworkProvider));
