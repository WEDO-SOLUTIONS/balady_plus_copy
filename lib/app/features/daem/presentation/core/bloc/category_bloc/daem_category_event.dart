part of 'daem_category_bloc.dart';

abstract class DaemCategoryEvent extends Equatable {
  const DaemCategoryEvent();

  @override
  List<Object> get props => [];
}

class GetDaemCategoryEvent extends DaemCategoryEvent {
  GetDaemCategoryEvent();
}

class GetDaemSubCategoryEvent extends DaemCategoryEvent {
  DaemItem category;
  GetDaemSubCategoryEvent(this.category);
}

class GetDaemMunicipalityEvent extends DaemCategoryEvent {
  GetDaemMunicipalityEvent();
}

class GetDaemMunicipalitiesAndSubCategoryEvent extends DaemCategoryEvent {
  DaemItem category;
  GetDaemMunicipalitiesAndSubCategoryEvent(this.category);
}

class GetDaemAreasEvent extends DaemCategoryEvent {
  DaemItem category;
  DaemItem subCategory;
  GetDaemAreasEvent({required this.category, required this.subCategory});
}

class GetDaemIssuesEvent extends DaemCategoryEvent {
  DaemItem category;
  DaemItem subCategory;
  DaemItem area;
  GetDaemIssuesEvent(
      {required this.category, required this.subCategory, required this.area});
}
