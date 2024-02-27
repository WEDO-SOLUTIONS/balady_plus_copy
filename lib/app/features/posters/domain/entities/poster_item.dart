// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../data/models/attachment_resposne_model.dart';
import '../../data/models/permit_poster_types_response.dart';

class PosterItem {
  final double? length;
  final double? width;
  final String? name;
  final PermitPosterTypeItem? posterType;
  final int? discountPercentage;
  final List<PermitAttachmentItem>? attachedDocuments;
  PosterItem(
      {this.length,
      this.width,
      this.name,
      this.posterType,
      this.attachedDocuments,
      this.discountPercentage});
}
