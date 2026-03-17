import 'base_response.dart';

class DownloadFilePathModel implements BaseData {
  String path;

  DownloadFilePathModel({required this.path});

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['path'] = path;
    return data;
  }
}