// To parse this JSON data, do
//
//     final lightWorkshopsModel = lightWorkshopsModelFromJson(jsonString);

import 'dart:convert';

LightWorkshopsModel lightWorkshopsModelFromJson(String str) => LightWorkshopsModel.fromJson(json.decode(str));

String lightWorkshopsModelToJson(LightWorkshopsModel data) => json.encode(data.toJson());

class LightWorkshopsModel {
    final List<Content>? content;

    LightWorkshopsModel({
        this.content,
    });

    LightWorkshopsModel copyWith({
        List<Content>? content,
    }) => 
        LightWorkshopsModel(
            content: content ?? this.content,
        );

    factory LightWorkshopsModel.fromJson(Map<String, dynamic> json) => LightWorkshopsModel(
        content: json["content"] == null ? [] : List<Content>.from(json["content"]!.map((x) => Content.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "content": content == null ? [] : List<dynamic>.from(content!.map((x) => x.toJson())),
    };
}

class Content {
    final String? term;
    final String? description;
    final List<Item>? item;
    final String? conditionNumber;
    final String? conditionName;

    Content({
        this.term,
        this.description,
        this.item,
        this.conditionNumber,
        this.conditionName,
    });

    Content copyWith({
        String? term,
        String? description,
        List<Item>? item,
        String? conditionNumber,
        String? conditionName,
    }) => 
        Content(
            term: term ?? this.term,
            description: description ?? this.description,
            item: item ?? this.item,
            conditionNumber: conditionNumber ?? this.conditionNumber,
            conditionName: conditionName ?? this.conditionName,
        );

    factory Content.fromJson(Map<String, dynamic> json) => Content(
        term: json["term"],
        description: json["description"],
        item: json["item"] == null ? [] : List<Item>.from(json["item"]!.map((x) => Item.fromJson(x))),
        conditionNumber: json["conditionNumber"],
        conditionName: json["conditionName"],
    );

    Map<String, dynamic> toJson() => {
        "term": term,
        "description": description,
        "item": item == null ? [] : List<dynamic>.from(item!.map((x) => x.toJson())),
        "conditionNumber": conditionNumber,
        "conditionName": conditionName,
    };
}

class Item {
    final List<AdditionalListCondition>? additionalListCondition;
    final String? subConditionOn;
    final String? subConditionName;
    final String? subConditionDescript;
    final String? additionDescripe;

    Item({
        this.additionalListCondition,
        this.subConditionOn,
        this.subConditionName,
        this.subConditionDescript,
        this.additionDescripe,
    });

    Item copyWith({
        List<AdditionalListCondition>? additionalListCondition,
        String? subConditionOn,
        String? subConditionName,
        String? subConditionDescript,
        String? additionDescripe,
    }) => 
        Item(
            additionalListCondition: additionalListCondition ?? this.additionalListCondition,
            subConditionOn: subConditionOn ?? this.subConditionOn,
            subConditionName: subConditionName ?? this.subConditionName,
            subConditionDescript: subConditionDescript ?? this.subConditionDescript,
            additionDescripe: additionDescripe ?? this.additionDescripe,
        );

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        additionalListCondition: json["additionalListCondition"] == null ? [] : List<AdditionalListCondition>.from(json["additionalListCondition"]!.map((x) => AdditionalListCondition.fromJson(x))),
        subConditionOn: json["subConditionOn"],
        subConditionName: json["subConditionName"],
        subConditionDescript: json["subConditionDescript"],
        additionDescripe: json["additionDescripe"],
    );

    Map<String, dynamic> toJson() => {
        "additionalListCondition": additionalListCondition == null ? [] : List<dynamic>.from(additionalListCondition!.map((x) => x.toJson())),
        "subConditionOn": subConditionOn,
        "subConditionName": subConditionName,
        "subConditionDescript": subConditionDescript,
        "additionDescripe": additionDescripe,
    };
}

class AdditionalListCondition {
    final List<ThirdList>? thirdList;
    final String? additionOn;
    final String? additionName;
    final String? additionDescripe;

    AdditionalListCondition({
        this.thirdList,
        this.additionOn,
        this.additionName,
        this.additionDescripe,
    });

    AdditionalListCondition copyWith({
        List<ThirdList>? thirdList,
        String? additionOn,
        String? additionName,
        String? additionDescripe,
    }) => 
        AdditionalListCondition(
            thirdList: thirdList ?? this.thirdList,
            additionOn: additionOn ?? this.additionOn,
            additionName: additionName ?? this.additionName,
            additionDescripe: additionDescripe ?? this.additionDescripe,
        );

    factory AdditionalListCondition.fromJson(Map<String, dynamic> json) => AdditionalListCondition(
        thirdList: json["thirdList"] == null ? [] : List<ThirdList>.from(json["thirdList"]!.map((x) => ThirdList.fromJson(x))),
        additionOn: json["additionOn"],
        additionName: json["additionName"],
        additionDescripe: json["additionDescripe"],
    );

    Map<String, dynamic> toJson() => {
        "thirdList": thirdList == null ? [] : List<dynamic>.from(thirdList!.map((x) => x.toJson())),
        "additionOn": additionOn,
        "additionName": additionName,
        "additionDescripe": additionDescripe,
    };
}

class ThirdList {
    final List<ListElement>? list;
    final String? title;

    ThirdList({
        this.list,
        this.title,
    });

    ThirdList copyWith({
        List<ListElement>? list,
        String? title,
    }) => 
        ThirdList(
            list: list ?? this.list,
            title: title ?? this.title,
        );

    factory ThirdList.fromJson(Map<String, dynamic> json) => ThirdList(
        list: json["list"] == null ? [] : List<ListElement>.from(json["list"]!.map((x) => ListElement.fromJson(x))),
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
        "title": title,
    };
}

class ListElement {
    final String? number;
    final String? name;
    final List<Sublist>? sublist;
    final List<Images>? images;
    final String? numbre;
    final List<SubItem>? subItem;

    ListElement({
        this.number,
        this.name,
        this.sublist,
        this.images,
        this.numbre,
        this.subItem,
    });

    ListElement copyWith({
        String? number,
        String? name,
        List<Sublist>? sublist,
        List<Images>? images,
        String? numbre,
        List<SubItem>? subItem,
    }) => 
        ListElement(
            number: number ?? this.number,
            name: name ?? this.name,
            sublist: sublist ?? this.sublist,
            images: images ?? this.images,
            numbre: numbre ?? this.numbre,
            subItem: subItem ?? this.subItem,
        );

    factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        number: json["number"],
        name: json["name"],
        sublist: json["sublist"] == null ? [] : List<Sublist>.from(json["sublist"]!.map((x) => Sublist.fromJson(x))),
        images: json["images"] == null ? [] : List<Images>.from(json["images"]!.map((x) => Images.fromJson(x))),
        numbre: json["numbre"],
        subItem: json["subItem"] == null ? [] : List<SubItem>.from(json["subItem"]!.map((x) => SubItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "number": number,
        "name": name,
        "sublist": sublist == null ? [] : List<dynamic>.from(sublist!.map((x) => x.toJson())),
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
        "numbre": numbre,
        "subItem": subItem == null ? [] : List<dynamic>.from(subItem!.map((x) => x.toJson())),
    };
}

class Images {
    final String? path;
    final String? description;
    final String? imgDescription;

    Images({
        this.path,
        this.description,
        this.imgDescription,
    });

    Images copyWith({
        String? path,
        String? description,
        String? imgDescription,
    }) => 
        Images(
            path: path ?? this.path,
            description: description ?? this.description,
            imgDescription: imgDescription ?? this.imgDescription,
        );

    factory Images.fromJson(Map<String, dynamic> json) => Images(
        path: json["path"],
        description: json["description"],
        imgDescription: json["imgDescription"],
    );

    Map<String, dynamic> toJson() => {
        "path": path,
        "description": description,
        "imgDescription": imgDescription,
    };
}

class SubItem {
    final String? subItemNumber;
    final String? subItemName;

    SubItem({
        this.subItemNumber,
        this.subItemName,
    });

    SubItem copyWith({
        String? subItemNumber,
        String? subItemName,
    }) => 
        SubItem(
            subItemNumber: subItemNumber ?? this.subItemNumber,
            subItemName: subItemName ?? this.subItemName,
        );

    factory SubItem.fromJson(Map<String, dynamic> json) => SubItem(
        subItemNumber: json["subItemNumber"],
        subItemName: json["subItemName"],
    );

    Map<String, dynamic> toJson() => {
        "subItemNumber": subItemNumber,
        "subItemName": subItemName,
    };
}

class Sublist {
    final String? title;
    final List<SybType>? sybType;

    Sublist({
        this.title,
        this.sybType,
    });

    Sublist copyWith({
        String? title,
        List<SybType>? sybType,
    }) => 
        Sublist(
            title: title ?? this.title,
            sybType: sybType ?? this.sybType,
        );

    factory Sublist.fromJson(Map<String, dynamic> json) => Sublist(
        title: json["title"],
        sybType: json["sybType"] == null ? [] : List<SybType>.from(json["sybType"]!.map((x) => SybType.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "sybType": sybType == null ? [] : List<dynamic>.from(sybType!.map((x) => x.toJson())),
    };
}

class SybType {
    final String? typeName;

    SybType({
        this.typeName,
    });

    SybType copyWith({
        String? typeName,
    }) => 
        SybType(
            typeName: typeName ?? this.typeName,
        );

    factory SybType.fromJson(Map<String, dynamic> json) => SybType(
        typeName: json["typeName"],
    );

    Map<String, dynamic> toJson() => {
        "typeName": typeName,
    };
}
