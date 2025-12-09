part of 'wrc.dart';

// list of strings set as. Must be all lower case letters
const _keywordsSet = <Set<String>>{
  {'wrc'},
  {'rally'},
};

/// query is successful only if it contains all of _keywords item words in any order
bool isWrcQuery(String query) {
  final queryWordsSet = query.toLowerCase().split(RegExp(r'\s')).nonNulls.map((e) => e).toSet();
  return _keywordsSet.any((keywords) => queryWordsSet.containsAll(keywords));
}
