import 'package:flutter/cupertino.dart';

class ExpandableDataModel{
   String title;
   bool isExpanded;
   Widget? expandable;

  ExpandableDataModel({required this.title, required this.isExpanded, required this.expandable});
}