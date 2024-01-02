import "package:channil/data.dart";

class Athlete {
  late final String id;
  final String first;
  final String last;
  final String email;
  final AthleteProfile profile;

  Athlete({
    required this.first, 
    required this.last, 
    required this.email, 
    required this.profile, 
  });
}

class AthleteProfile {
  final String college;
  final int graduationYear;
  final String sport;
  final String pronouns;
  final String socialMedia;
  final int followerCount;
  final List<ImageWithCaption> profileImagesUrls;
  final Map<String, String> prompts;
  final Set<String> dealPreferences;

  AthleteProfile({
    required this.college,
    required this.graduationYear,
    required this.sport,
    required this.pronouns,
    required this.socialMedia,
    required this.followerCount,
    required this.profileImagesUrls,
    required this.prompts,
    required this.dealPreferences,
  });
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
