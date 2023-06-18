import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show AddetionalDetailsItem, SupportingMaterialsItem;
import 'package:equatable/equatable.dart';

class SPLDetailsResponse extends Equatable {
  String? id;
  String? name;
  List<AddetionalDetailsItem>? questionList;
  List<SupportingMaterialsItem>? supportingMaterialsList;
  List<String>? helpingImages;
  String? selectedSPLID;

  SPLDetailsResponse(
      {this.id,
      this.name,
      this.questionList,
      this.supportingMaterialsList,
      this.helpingImages,
      this.selectedSPLID});

  List<String> getHelpingImages() {
    return supportingMaterialsList != null
        ? supportingMaterialsList!
            .where((e) =>
                e.auxillaryMaterialType == "Image" && e.getImageUrl() != null)
            .toList()
            .map((e) => e.getImageUrl()!)
            .toList()
        : [];
  }

  @override
  List<Object?> get props => [id, selectedSPLID, questionList];
}
