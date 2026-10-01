import 'package:mapness/features/favorite_lists/data/models/share_link_dto.dart';

sealed class FavoriteListFormParams {
  const FavoriteListFormParams();
}

class CreateFavoriteListParams extends FavoriteListFormParams {
  const CreateFavoriteListParams();
}

class UpdateFavoriteListParams extends FavoriteListFormParams {
  final String listId;

  const UpdateFavoriteListParams({required this.listId});
}

class AcceptSharedFavoriteListParams extends FavoriteListFormParams {
  final String shareToken;
  final SharedListPreviewDto preview;

  const AcceptSharedFavoriteListParams({required this.shareToken, required this.preview});
}
