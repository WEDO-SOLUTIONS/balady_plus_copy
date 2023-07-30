class SearchParams {
  String text;
  String pageIndex;

  SearchParams({required this.pageIndex, required this.text});

  SearchParams copyWith({
    String? text,
    String? pageIndex,
  }) {
    return SearchParams(
        pageIndex: pageIndex ?? this.pageIndex, text: text ?? this.text);
  }
}
