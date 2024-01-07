import "utils.dart";

class ChannilImage {
  String url;
  String? caption;

  ChannilImage({
    required this.url, 
    this.caption,
  });

  ChannilImage.fromJson(Json json) : 
    url = json["url"],
    caption = json["caption"];

  Json toJson() => {
    "url": url,
    "caption": caption,
  };
}
