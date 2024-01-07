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
  final Sport sport;
  final String pronouns;
  final List<SocialMediaProfile> socials;
  final List<ChannilImage> profilePics;
  final Map<String, String> prompts;
  final Set<DealCategory> dealPreferences;

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

  Json toJson() => {
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
      for (final name in json["categories"]) DealCategory.values.byName(name),
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
