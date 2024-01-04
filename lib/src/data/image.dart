import "utils.dart";

enum ImageType {
  file, 
  network,
}

class ImageWithCaption {
  ImageType type;
  String imageUrl;
  String caption;

  ImageWithCaption({
    required this.imageUrl, 
    required this.caption,
    required this.type,
  });

  ImageWithCaption.fromFile(String path) : 
    type = ImageType.file,
    imageUrl = path,
    caption = "";

  ImageWithCaption.fromJson(Json json) : 
    imageUrl = json["imageUrl"],
    caption = json["caption"],
    type = ImageType.values[json["type"]];

  Json toJson() => {
    "imageUrl": imageUrl,
    "caption": caption,
    "type": type.index,
  };
}
