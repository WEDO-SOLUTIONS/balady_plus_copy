import 'package:balady_plus/app/features/vd/data/model/spl_details/additional_details_item_model.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show
        AddetionalDetailsItem,
        SPLDetailsResponse,
        AddetionalDetailsItem,
        SupportingMaterialsItem,
        SupportingMaterialsItemModel;
import 'package:equatable/equatable.dart';

class SPLDetailsResponseModel extends SPLDetailsResponse {
  SPLDetailsResponseModel(
      {super.id,
      super.name,
      super.questionList,
      super.supportingMaterialsList});

  factory SPLDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    SPLDetailsResponseModel item = SPLDetailsResponseModel(
        id: json["ID"],
        name: json["Name"],
        questionList: json["additionalDetailsList"] != null
            ? List<AddetionalDetailsItem>.from(json["additionalDetailsList"]
                .map((x) => AddetionalDetailsItemModel.fromJson(x)))
            : [],
        supportingMaterialsList: json["SupportingMaterialsList"] != null
            ? List<SupportingMaterialsItem>.from(json["SupportingMaterialsList"]
                .map((x) => SupportingMaterialsItemModel.fromJson(x)))
            : []);

    item.helpingImages = item.getHelpingImages();
    return item;
  }

  Map<String, dynamic> toJson() => {
        "QuestionList": questionList != null
            ? List<dynamic>.from(questionList!.map((x) => x.toModel.toJson()))
            : null,
        "ID": id,
        "Name": name
      };

  @override
  List<Object?> get props => [id];
}
