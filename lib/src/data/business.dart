import "package:channil/data.dart";

class Business {
  final String id;
  final String name;
  final String email;
  final DealCategory industry;
  final String location;
  final String socialMediaLink;
  final String? website;
  final Set<Sport> sports;
  
  final ChannilImage logo;
  final ChannilImage? productImage;
  final List<ChannilImage?> additionalImages;

  Business({
    required this.id,
    required this.name,
    required this.email,
    required this.industry,
    required this.location,
    required this.socialMediaLink,
    required this.website,
    required this.sports,
    required this.logo,
    required this.productImage,
    required this.additionalImages,
  });

  Business.fromJson(Json json) : 
    id = json["id"],
    name = json["name"],
    email = json["email"],
    industry = DealCategory.values.byName(json["industry"]),
    location = json["location"],
    socialMediaLink = json["socialMediaLink"],
    website = json["website"],
    sports = {
      for (final sport in json["sports"]) Sport.values.byName(sport),
    },
    logo = ChannilImage.fromJson(json["logo"]),
    productImage = json["productImage"] == null ? null : ChannilImage.fromJson(json["productImage"]),
    additionalImages = [
      for (final imageJson in json["additionalImages"])
        ChannilImage.fromJson(imageJson),
    ];
  
  Json toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "industry": industry.name,
    "location": location,
    "socialMediaLink": socialMediaLink,
    "website": website,
    "sports": [
      for (final sport in sports) sport.name,
    ],
    "logo": logo.toJson(),
    "productImage": productImage?.toJson(),
    "additionalImageUrls": [
      for (final image in additionalImages) image?.toJson(),
    ],
  };
}
