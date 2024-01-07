import "utils.dart";

enum SocialMediaPlatform {
  instagram(displayName: "Instagram", logoUrl: "https://static.cdninstagram.com/rsrc.php/v3/yI/r/VsNE-OHk_8a.png", urlPrefix: "https://instagram.com/"),
  twitter(displayName: "X (Twitter)", logoUrl: "https://abs.twimg.com/favicons/twitter.3.ico", urlPrefix: "https://x.com/"),
  linkedin(displayName: "LinkedIn", logoUrl: "https://static.licdn.com/aero-v1/sc/h/3loy7tajf3n0cho89wgg0fjre"),
  facebook(displayName: "Facebook", logoUrl: "https://static.xx.fbcdn.net/rsrc.php/yb/r/hLRJ1GG_y0J.ico", urlPrefix: "https://facebook.com/"),
  tikTok(displayName: "TikTok", logoUrl: "https://www.tiktok.com/favicon.ico", urlPrefix: "https://tiktok.com/@");

  final String displayName;
  final String logoUrl;
  final String? urlPrefix;
  const SocialMediaPlatform({required this.displayName, required this.logoUrl, this.urlPrefix});
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
