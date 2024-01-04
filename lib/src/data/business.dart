import "utils.dart";

class Business {
  final String id;
  final String name;
  final String email;
  final String industry;
  final String location;
  final String socialMediaLink;
  final String? website;
  
  final String logoUrl;
  final String? productImageUrl;
  final List<String> additionalImageUrls;

  Business({
    required this.id,
    required this.name,
    required this.email,
    required this.industry,
    required this.location,
    required this.socialMediaLink,
    required this.website,
    required this.logoUrl,
    required this.productImageUrl,
    required this.additionalImageUrls,
  });

  Business.fromJson(Json json) : 
    id = json["id"],
    name = json["name"],
    email = json["email"],
    industry = json["industry"],
    location = json["location"],
    socialMediaLink = json["socialMediaLink"],
    website = json["website"],
    logoUrl = json["logoUrl"],
    productImageUrl = json["productImageUrl"],
    additionalImageUrls = json["additionalImageUrls"];
  
  Json toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "industry": industry,
    "location": location,
    "socialMediaLink": socialMediaLink,
    "website": website,
    "logoUrl": logoUrl,
    "productImageUrl": productImageUrl,
    "additionalImageUrls": additionalImageUrls,
  };
}
