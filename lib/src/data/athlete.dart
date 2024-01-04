import "package:channil/data.dart";

class Athlete {
  final String id;
  final String first;
  final String last;
  final String email;
  final AthleteProfile profile;

  Athlete({
    required this.id,
    required this.first,
    required this.last,
    required this.email,
    required this.profile,
  });

  Json toJson() => {
    "id": id,
    "first": first,
    "last": last,
    "email": email,
    "profile": profile.toJson(),
  };

  Athlete.fromJson(Json json) : 
    id = json["id"],
    first = json["first"],
    last = json["last"],
    email = json["email"],
    profile = AthleteProfile.fromJson(json["profile"]);
}

class AthleteProfile {
  final String college;
  final int graduationYear;
  final String sport;
  final String pronouns;
  final String socialMedia;
  final int followerCount;
  final List<ImageWithCaption> profilePics;
  final Map<String, String> prompts;
  final Set<String> dealPreferences;

  AthleteProfile({
    required this.college,
    required this.graduationYear,
    required this.sport,
    required this.pronouns,
    required this.socialMedia,
    required this.followerCount,
    required this.profilePics,
    required this.prompts,
    required this.dealPreferences,
  });

  Json toJson() => {
    "college": college,
    "graduationYear": graduationYear,
    "sport": sport,
    "pronouns": pronouns,
    "socialMedia": socialMedia,
    "followerCount": followerCount,
    "profilePics": [
      for (final image in profilePics) 
        image.toJson(),
     ],
    "prompts": prompts,
    "dealPreferences": dealPreferences.toList(),
  };

  AthleteProfile.fromJson(Map<String, dynamic> json) :
    college = json["college"],
    graduationYear = json["graduationYear"],
    sport = json["sport"],
    pronouns = json["pronouns"],
    socialMedia = json["socialMedia"],
    followerCount = json["followerCount"],
    profilePics = [
      for (final imageJson in json["profilePics"])
        ImageWithCaption.fromJson(imageJson),
    ],
    prompts = Map<String, String>.from(json["prompts"]),
    dealPreferences = Set<String>.from(json["dealPreferences"]);
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

const allDealTypes = [
  "Athletic Gear",
  "Flowers",
  "Product",
  "Niche",
  "Clothing",
  "Lifestyle",
];
