class Picture {
  final String? caption;
  final String? url;

  Picture({
    this.caption,
    this.url,
  });

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
        caption: json["caption"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "caption": caption,
        "url": url,
      };
}
