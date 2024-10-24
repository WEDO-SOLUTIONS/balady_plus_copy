import '/app/features/home/domain/entities/news_response.dart';

class NewsResponseModel extends NewsResponse {
  const NewsResponseModel({
    super.statusCode,
    super.data,
  });

  factory NewsResponseModel.fromMap(Map<String, dynamic> json) =>
      NewsResponseModel(
        statusCode: json["statusCode"],
        data: json["data"] == null ? null : DataModel.fromMap(json["data"]),
      );
}

class DataModel extends Data {
  const DataModel({
    super.pageIndex,
    super.pageCount,
    super.totalCount,
    super.dataList,
  });

  factory DataModel.fromMap(Map<String, dynamic> json) => DataModel(
        pageIndex: json["pageIndex"],
        pageCount: json["pageCount"],
        totalCount: json["totalCount"],
        dataList: json["dataList"] == null
            ? []
            : List<NewsItemModel>.from(
                json["dataList"]!.map((x) => NewsItemModel.fromMap(x))),
      );
}

class NewsItemModel extends NewsItem {
  const NewsItemModel({
    super.id,
    super.title,
    super.description,
    super.creationDate,
    super.modificationDate,
    super.isOnHome,
    super.publishingImage,
    super.rollUpImage,
    super.categoryId,
    super.category,
  });

  factory NewsItemModel.fromMap(Map<String, dynamic> json) => NewsItemModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        creationDate: json["creationDate"] == null
            ? null
            : DateTime.parse(json["creationDate"]),
        modificationDate: json["modificationDate"] == null
            ? null
            : DateTime.parse(json["modificationDate"]),
        isOnHome: json["isOnHome"],
        publishingImage: json["publishingImage"],
        rollUpImage: json["rollUpImage"],
        categoryId: json["categoryId"],
        category: json["category"],
      );
}
