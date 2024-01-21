import "package:channil/data.dart";

// Subclassed for different types of profiles.
abstract class Profile {
  Profile();

  factory Profile.fromJson(Json json) => switch(json["type"]) {
    "athlete" => AthleteProfile.fromJson(json),
    "business" => BusinessProfile.fromJson(json),
    _ => throw FormatException("Unknown profile type: ${json["type"]}"),
  };

  Json toJson();
}
