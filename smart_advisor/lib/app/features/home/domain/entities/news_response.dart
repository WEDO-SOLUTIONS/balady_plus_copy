import 'package:equatable/equatable.dart';

class NewsResponse extends Equatable {
  final int? statusCode;
  final Data? data;

  const NewsResponse({
    this.statusCode,
    this.data,
  });

  @override
  List<Object?> get props => [];
}

class Data extends Equatable {
  final int? pageIndex;
  final int? pageCount;
  final int? totalCount;
  final List<NewsItem>? dataList;

  const Data({
    this.pageIndex,
    this.pageCount,
    this.totalCount,
    this.dataList,
  });

  @override
  List<Object?> get props => [];
}

class NewsItem extends Equatable {
  final int? id;
  final String? title;
  final String? description;
  final DateTime? creationDate;
  final DateTime? modificationDate;
  final String? isOnHome;
  final String? publishingImage;
  final String? rollUpImage;
  final int? categoryId;
  final String? category;

  const NewsItem({
    this.id,
    this.title,
    this.description,
    this.creationDate,
    this.modificationDate,
    this.isOnHome,
    this.publishingImage,
    this.rollUpImage,
    this.categoryId,
    this.category,
  });

  @override
  List<Object?> get props => [];

  String get getIconUrl => "http://portal.ac.main.is.sa/${rollUpImage!}";
}
