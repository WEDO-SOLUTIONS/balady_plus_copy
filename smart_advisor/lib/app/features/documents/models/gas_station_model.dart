// To parse this JSON data, do
//
//     final gasStationModel = gasStationModelFromJson(jsonString);

import 'dart:convert';

GasStationModel gasStationModelFromJson(String str) => GasStationModel.fromJson(json.decode(str));

String gasStationModelToJson(GasStationModel data) => json.encode(data.toJson());

class GasStationModel {
    final List<Content>? content;

    GasStationModel({
        this.content,
    });

    GasStationModel copyWith({
        List<Content>? content,
    }) => 
        GasStationModel(
            content: content ?? this.content,
        );

    factory GasStationModel.fromJson(Map<String, dynamic> json) => GasStationModel(
        content: json["content"] == null ? [] : List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "content": content == null ? [] : List<dynamic>.from(content!.map((x) => x.toJson())),
    };
}

class Content {
    final String? type;
    final String? title;
    final List<ContentItem>? items;

    Content({
        this.type,
        this.title,
        this.items,
    });

    Content copyWith({
        String? type,
        String? title,
        List<ContentItem>? items,
    }) => 
        Content(
            type: type ?? this.type,
            title: title ?? this.title,
            items: items ?? this.items,
        );

    factory Content.fromJson(Map<String, dynamic> json) => Content(
        type: json["type"],
        title: json["title"],
        items: json["items"] == null ? [] : List<ContentItem>.from(json["items"]!.map((x) => ContentItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "title": title,
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    };
}

class ContentItem {
    final String? number;
    final String? description;
    final List<FluffySubItem>? subItems;
    final List<Annex>? annex;

    ContentItem({
        this.number,
        this.description,
        this.subItems,
        this.annex,
    });

    ContentItem copyWith({
        String? number,
        String? description,
        List<FluffySubItem>? subItems,
        List<Annex>? annex,
    }) => 
        ContentItem(
            number: number ?? this.number,
            description: description ?? this.description,
            subItems: subItems ?? this.subItems,
            annex: annex ?? this.annex,
        );

    factory ContentItem.fromJson(Map<String, dynamic> json) => ContentItem(
        number: json["number"],
        description: json["description"],
        subItems: json["sub_items"] == null ? [] : List<FluffySubItem>.from(json["sub_items"]!.map((x) => FluffySubItem.fromJson(x))),
        annex: json["annex"] == null ? [] : List<Annex>.from(json["annex"]!.map((x) => Annex.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "number": number,
        "description": description,
        "sub_items": subItems == null ? [] : List<dynamic>.from(subItems!.map((x) => x.toJson())),
        "annex": annex == null ? [] : List<dynamic>.from(annex!.map((x) => x.toJson())),
    };
}

class Annex {
    final String? title;
    final String? englishName;
    final String? arabicName;
    final List<Standard>? standards;
    final String? note;
    final List<AnnexItem>? items;

    Annex({
        this.title,
        this.englishName,
        this.arabicName,
        this.standards,
        this.note,
        this.items,
    });

    Annex copyWith({
        String? title,
        String? englishName,
        String? arabicName,
        List<Standard>? standards,
        String? note,
        List<AnnexItem>? items,
    }) => 
        Annex(
            title: title ?? this.title,
            englishName: englishName ?? this.englishName,
            arabicName: arabicName ?? this.arabicName,
            standards: standards ?? this.standards,
            note: note ?? this.note,
            items: items ?? this.items,
        );

    factory Annex.fromJson(Map<String, dynamic> json) => Annex(
        title: json["title"],
        englishName: json["english_name"],
        arabicName: json["arabic_name"],
        standards: json["standards"] == null ? [] : List<Standard>.from(json["standards"]!.map((x) => Standard.fromJson(x))),
        note: json["note"],
        items: json["items"] == null ? [] : List<AnnexItem>.from(json["items"]!.map((x) => AnnexItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "english_name": englishName,
        "arabic_name": arabicName,
        "standards": standards == null ? [] : List<dynamic>.from(standards!.map((x) => x.toJson())),
        "note": note,
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    };
}

class AnnexItem {
    final String? number;
    final String? englishTitle;
    final String? arabicTitle;
    final String? description;
    final List<PurpleSubItem>? subItems;

    AnnexItem({
        this.number,
        this.englishTitle,
        this.arabicTitle,
        this.description,
        this.subItems,
    });

    AnnexItem copyWith({
        String? number,
        String? englishTitle,
        String? arabicTitle,
        String? description,
        List<PurpleSubItem>? subItems,
    }) => 
        AnnexItem(
            number: number ?? this.number,
            englishTitle: englishTitle ?? this.englishTitle,
            arabicTitle: arabicTitle ?? this.arabicTitle,
            description: description ?? this.description,
            subItems: subItems ?? this.subItems,
        );

    factory AnnexItem.fromJson(Map<String, dynamic> json) => AnnexItem(
        number: json["number"],
        englishTitle: json["english_title"],
        arabicTitle: json["arabic_title"],
        description: json["description"],
        subItems: json["sub_items"] == null ? [] : List<PurpleSubItem>.from(json["sub_items"]!.map((x) => PurpleSubItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "number": number,
        "english_title": englishTitle,
        "arabic_title": arabicTitle,
        "description": description,
        "sub_items": subItems == null ? [] : List<dynamic>.from(subItems!.map((x) => x.toJson())),
    };
}

class PurpleSubItem {
    final String? subNumber;
    final String? englishTitle;
    final String? arabicTitle;
    final String? description;
    final List<TableOrder>? tables;
    final List<Section>? sections;
    final List<SubItemCategory>? categories;

    PurpleSubItem({
        this.subNumber,
        this.englishTitle,
        this.arabicTitle,
        this.description,
        this.tables,
        this.sections,
        this.categories,
    });

    PurpleSubItem copyWith({
        String? subNumber,
        String? englishTitle,
        String? arabicTitle,
        String? description,
        List<TableOrder>? tables,
        List<Section>? sections,
        List<SubItemCategory>? categories,
    }) => 
        PurpleSubItem(
            subNumber: subNumber ?? this.subNumber,
            englishTitle: englishTitle ?? this.englishTitle,
            arabicTitle: arabicTitle ?? this.arabicTitle,
            description: description ?? this.description,
            tables: tables ?? this.tables,
            sections: sections ?? this.sections,
            categories: categories ?? this.categories,
        );

    factory PurpleSubItem.fromJson(Map<String, dynamic> json) => PurpleSubItem(
        subNumber: json["sub_number"],
        englishTitle: json["english_title"],
        arabicTitle: json["arabic_title"],
        description: json["description"],
        tables: json["tables"] == null ? [] : List<TableOrder>.from(json["tables"]!.map((x) => TableOrder.fromJson(x))),
        sections: json["sections"] == null ? [] : List<Section>.from(json["sections"]!.map((x) => Section.fromJson(x))),
        categories: json["categories"] == null ? [] : List<SubItemCategory>.from(json["categories"]!.map((x) => SubItemCategory.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "sub_number": subNumber,
        "english_title": englishTitle,
        "arabic_title": arabicTitle,
        "description": description,
        "tables": tables == null ? [] : List<dynamic>.from(tables!.map((x) => x.toJson())),
        "sections": sections == null ? [] : List<dynamic>.from(sections!.map((x) => x.toJson())),
        "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
    };
}

class SubItemCategory {
    final String? code;
    final String? description;

    SubItemCategory({
        this.code,
        this.description,
    });

    SubItemCategory copyWith({
        String? code,
        String? description,
    }) => 
        SubItemCategory(
            code: code ?? this.code,
            description: description ?? this.description,
        );

    factory SubItemCategory.fromJson(Map<String, dynamic> json) => SubItemCategory(
        code: json["code"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "description": description,
    };
}

class Section {
    final String? subNumber;
    final String? name;
    final List<SectionCategory>? categories;
    final String? englishTitle;
    final String? arabicTitle;
    final String? description;
    final String? code;

    Section({
        this.subNumber,
        this.name,
        this.categories,
        this.englishTitle,
        this.arabicTitle,
        this.description,
        this.code,
    });

    Section copyWith({
        String? subNumber,
        String? name,
        List<SectionCategory>? categories,
        dynamic englishTitle,
        String? arabicTitle,
        String? description,
        String? code,
    }) => 
        Section(
            subNumber: subNumber ?? this.subNumber,
            name: name ?? this.name,
            categories: categories ?? this.categories,
            englishTitle: englishTitle ?? this.englishTitle,
            arabicTitle: arabicTitle ?? this.arabicTitle,
            description: description ?? this.description,
            code: code ?? this.code,
        );

    factory Section.fromJson(Map<String, dynamic> json) => Section(
        subNumber: json["sub_number"],
        name: json["name"],
        categories: json["categories"] == null ? [] : List<SectionCategory>.from(json["categories"]!.map((x) => SectionCategory.fromJson(x))),
        englishTitle: json["english_title"],
        arabicTitle: json["arabic_title"],
        description: json["description"],
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "sub_number": subNumber,
        "name": name,
        "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "english_title": englishTitle,
        "arabic_title": arabicTitle,
        "description": description,
        "code": code,
    };
}

class SectionCategory {
    final String? code;
    final String? description;
    final List<AdditionalRequirement>? additionalRequirements;

    SectionCategory({
        this.code,
        this.description,
        this.additionalRequirements,
    });

    SectionCategory copyWith({
        String? code,
        String? description,
        List<AdditionalRequirement>? additionalRequirements,
    }) => 
        SectionCategory(
            code: code ?? this.code,
            description: description ?? this.description,
            additionalRequirements: additionalRequirements ?? this.additionalRequirements,
        );

    factory SectionCategory.fromJson(Map<String, dynamic> json) => SectionCategory(
        code: json["code"],
        description: json["description"],
        additionalRequirements: json["additional_requirements"] == null ? [] : List<AdditionalRequirement>.from(json["additional_requirements"]!.map((x) => AdditionalRequirement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "description": description,
        "additional_requirements": additionalRequirements == null ? [] : List<dynamic>.from(additionalRequirements!.map((x) => x.toJson())),
    };
}

class AdditionalRequirement {
    final String? code;
    final String? name;

    AdditionalRequirement({
        this.code,
        this.name,
    });

    AdditionalRequirement copyWith({
        String? code,
        String? name,
    }) => 
        AdditionalRequirement(
            code: code ?? this.code,
            name: name ?? this.name,
        );

    factory AdditionalRequirement.fromJson(Map<String, dynamic> json) => AdditionalRequirement(
        code: json["code"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
    };
}

class TableOrder {
    final String? upBoundary;
    final String? downBoundary;

    TableOrder({
        this.upBoundary,
        this.downBoundary,
    });

    TableOrder copyWith({
        String? upBoundary,
        String? downBoundary,
    }) => 
        TableOrder(
            upBoundary: upBoundary ?? this.upBoundary,
            downBoundary: downBoundary ?? this.downBoundary,
        );

    factory TableOrder.fromJson(Map<String, dynamic> json) => TableOrder(
        upBoundary: json["up_boundary"],
        downBoundary: json["down_boundary"],
    );

    Map<String, dynamic> toJson() => {
        "up_boundary": upBoundary,
        "down_boundary": downBoundary,
    };
}

class Standard {
    final String? standardNumber;
    final String? englishTitle;
    final String? arabicTitle;
    final String? order;

    Standard({
        this.standardNumber,
        this.englishTitle,
        this.arabicTitle,
        this.order,
    });

    Standard copyWith({
        String? standardNumber,
        String? englishTitle,
        String? arabicTitle,
        dynamic order,
    }) => 
        Standard(
            standardNumber: standardNumber ?? this.standardNumber,
            englishTitle: englishTitle ?? this.englishTitle,
            arabicTitle: arabicTitle ?? this.arabicTitle,
            order: order ?? this.order,
        );

    factory Standard.fromJson(Map<String, dynamic> json) => Standard(
        standardNumber: json["standard_number"],
        englishTitle: json["english_title"],
        arabicTitle: json["arabic_title"],
        order: json["order"],
    );

    Map<String, dynamic> toJson() => {
        "standard_number": standardNumber,
        "english_title": englishTitle,
        "arabic_title": arabicTitle,
        "order": order,
    };
}

class FluffySubItem {
    final String? subNumber;
    final String? name;

    FluffySubItem({
        this.subNumber,
        this.name,
    });

    FluffySubItem copyWith({
        String? subNumber,
        String? name,
    }) => 
        FluffySubItem(
            subNumber: subNumber ?? this.subNumber,
            name: name ?? this.name,
        );

    factory FluffySubItem.fromJson(Map<String, dynamic> json) => FluffySubItem(
        subNumber: json["sub_number"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "sub_number": subNumber,
        "name": name,
    };
}