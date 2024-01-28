import "package:channil/data.dart";

typedef UserID = String;
typedef Email = String;

class ChannilUser {
  final UserID id;
  final String name;
  final String email;
  final Profile profile;

  const ChannilUser({
    required this.id,
    required this.email,
    required this.name,
    required this.profile,
  });

  ChannilUser.fromJson(Json json) : 
    id = json["id"],
    name = json["name"],
    email = json["email"],
    profile = Profile.fromJson(json["profile"]);

  Json toJson() => {
    "id": id,
    "email": email,
    "name": name,
    "profile": profile.toJson(),
  };

  T matchProfileType<T>({
    required T Function(BusinessProfile) handleBusiness,
    required T Function(AthleteProfile) handleAthlete,
  }) => switch (profile) {
    (final BusinessProfile profile) => handleBusiness(profile),
    (final AthleteProfile profile) => handleAthlete(profile),
  };
}
