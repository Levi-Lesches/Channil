import "utils.dart";

enum SocialMediaPlatform {
  instagram(
    displayName: "Instagram",
    showFollowers: true,
    assetPath: "assets/logos/instagram.png",
    urlPrefix: "https://instagram.com/",
  ),
  tikTok(
    displayName: "TikTok",
    showFollowers: true,
    assetPath: "assets/logos/tiktok.jpg",
    urlPrefix: "https://tiktok.com/@",
  ),
  twitter(
    displayName: "X (Twitter)",
    showFollowers: false,
    assetPath: "assets/logos/x.webp",
    urlPrefix: "https://x.com/",
  ),
  linkedin(
    displayName: "LinkedIn",
    showFollowers: false,
    assetPath: "assets/logos/linkedin.png",
  );

  final String displayName;
  final String? urlPrefix;
  final String assetPath;
  final bool showFollowers;
  const SocialMediaPlatform({
    required this.assetPath, 
    required this.showFollowers, 
    required this.displayName, 
    this.urlPrefix,
  });
}

class SocialMediaProfile {
  final SocialMediaPlatform platform;
  final String username;
  final FollowerRange followerCount;
  final String? url;
  
  SocialMediaProfile({required this.platform, required this.username, required this.followerCount, this.url});

  SocialMediaProfile.fromJson(Json json) : 
    platform = SocialMediaPlatform.values.byName(json["platform"]),
    username = json["username"],
    followerCount = (json["followerCount_min"], json["followerCount_max"]),
    url = json["url"];

  Json toJson() => {
    "platform": platform.name,
    "username": username,
    "followerCount_min": followerCount.$1,
    "followerCount_max": followerCount.$2,
    "url": url,
  };
} 

typedef FollowerRange = (int min, int? max);
const List<FollowerRange> followerRanges = [
  (0, 1000),
  (1000, 2500), 
  (2500, 5000),
  (5000, 10000), 
  (10000, null),
];
