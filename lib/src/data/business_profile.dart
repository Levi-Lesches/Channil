import "package:channil/data.dart";

class BusinessProfile extends Profile {
  final Set<Industry> industries;
  final List<SocialMediaProfile> socials;
  final String location;
  final String? website;
  final Set<Sport> sports;
  
  final ChannilImage logo;
  final ChannilImage? productImage;
  final List<ChannilImage?> additionalImages;

  BusinessProfile({
    required this.industries,
    required this.location,
    required this.socials,
    required this.website,
    required this.sports,
    required this.logo,
    required this.productImage,
    required this.additionalImages,
  });

  BusinessProfile.fromJson(Json json) : 
    industries = {
      for (final industryJson in json["industries"])
        Industry.values.byName(industryJson as String),
    },
    location = json["location"],
    socials = [
      for (final socialJson in json["socialMedia"])
      SocialMediaProfile.fromJson(socialJson),
    ],
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
  
  @override
  Json toJson() => {
    "type": "business",
    "industries": [
      for (final industry in industries) industry.name,
    ],
    "location": location,
    "socials": [
      for (final social in socials) social.toJson(),
    ],
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
