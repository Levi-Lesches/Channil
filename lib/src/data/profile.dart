import "package:channil/data.dart";

// Subclassed for different types of profiles.
sealed class Profile {
  Profile();

  factory Profile.fromJson(Json json) => switch(json["type"]) {
    "athlete" => AthleteProfile.fromJson(json),
    "business" => BusinessProfile.fromJson(json),
    _ => throw FormatException("Unknown profile type: ${json["type"]}"),
  };

  Json toJson();
}

class AthleteProfile extends Profile {
  final String college;
  final int graduationYear;
  final Sport sport;
  final String pronouns;
  final List<SocialMediaProfile> socials;
  final List<ChannilImage> profilePics;
  final Map<String, String> prompts;
  final Set<Industry> dealPreferences;

  AthleteProfile({
    required this.college,
    required this.graduationYear,
    required this.sport,
    required this.pronouns,
    required this.socials,
    required this.profilePics,
    required this.prompts,
    required this.dealPreferences,
  });

  @override
  Json toJson() => {
    "type": "athlete",
    "college": college,
    "graduationYear": graduationYear,
    "sport": sport.name,
    "pronouns": pronouns,
    "socials": [
      for (final social in socials) social.toJson(),
    ],
    "profilePics": [
      for (final image in profilePics) 
        image.toJson(),
     ],
    "prompts": prompts,
    "dealPreferences": [for (final preference in dealPreferences) preference.name],
  };

  AthleteProfile.fromJson(Map<String, dynamic> json) :
    college = json["college"],
    graduationYear = json["graduationYear"],
    sport = Sport.values.byName(json["sport"]),
    pronouns = json["pronouns"],
    socials = [
      for (final socialJson in json["socials"]) 
        SocialMediaProfile.fromJson(socialJson),
    ],
    profilePics = [
      for (final imageJson in json["profilePics"])
        ChannilImage.fromJson(imageJson),
    ],
    prompts = Map<String, String>.from(json["prompts"]),
    dealPreferences = {
      for (final name in json["dealPreferences"]) Industry.values.byName(name),
    };
}

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
      for (final socialJson in json["socials"])
      SocialMediaProfile.fromJson(socialJson),
    ],
    website = json["website"],
    sports = {
      for (final sport in json["sports"]) Sport.values.byName(sport),
    },
    logo = ChannilImage.fromJson(json["logo"]),
    productImage = json["productImage"] == null ? null : ChannilImage.fromJson(json["productImage"]),
    additionalImages = [
      for (final imageJson in json["additionalImageUrls"])
        imageJson == null ? null : ChannilImage.fromJson(imageJson),
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

const allPrompts = [
  "My go-to post-game meal is...",
  "My favorite time to practice is...",
  "If I could play a different Division 1 sport that wasn't my own, I'd play...",
  "My teammates would describe me as...",
  "The first thing I do when I wake up is...",
  "After a big win I like to celebrate by...",
  "Other than myself, a person I attribute my success to is...",
  r"If I was given $1,000 to spend all in one store, it would be...",
  "A weakness in my sport that I wish was a strength is...",
  "My favorite hobby outside of sports is...",
];
