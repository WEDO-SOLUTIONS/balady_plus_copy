import '../../../_shared_feature_/data/entities/file_data_item.dart';

class ReasonModel {
  FileDataItem? file;
  String? notes;
  String? guid; 
  ReasonModel({
    this.file,
    this.notes, this.guid
  });
}
