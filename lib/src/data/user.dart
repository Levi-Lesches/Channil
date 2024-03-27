import "package:channil/data.dart";

class ChannilUser {
  final UserID id;
  final String name;
  final String email;
  final bool isHidden;
  final Profile profile;

  const ChannilUser({
    required this.id,
    required this.email,
    required this.name,
    required this.profile,
    this.isHidden = false,
  });

  ChannilUser.fromJson(Json json) : 
    id = json["id"],
    name = json["name"],
    email = json["email"],
    isHidden = json["isHidden"] ?? false,
    profile = Profile.fromJson(json["profile"]);

  Json toJson() => {
    "id": id,
    "email": email,
    "name": name,
    "isHidden": isHidden,
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
