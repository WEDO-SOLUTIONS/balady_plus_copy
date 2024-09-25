class SubmitApprovelModel {
  SubmitApprovelModel({
      this.selectedTerms,});

  SubmitApprovelModel.fromJson(dynamic json) {
    if (json['selectedTerms'] != null) {
      selectedTerms = [];
      json['selectedTerms'].forEach((v) {
        selectedTerms?.add(SelectedTerms.fromJson(v));
      });
    }
  }
  List<SelectedTerms>? selectedTerms;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (selectedTerms != null) {
      map['selectedTerms'] = selectedTerms?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class SelectedTerms {
  SelectedTerms({
      this.key, 
      this.selected, 
      this.text,});

  SelectedTerms.fromJson(dynamic json) {
    key = json['key'];
    selected = json['selected'];
    text = json['text'];
  }
  String? key;
  bool? selected;
  String? text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['selected'] = selected;
    map['text'] = text;
    return map;
  }

}