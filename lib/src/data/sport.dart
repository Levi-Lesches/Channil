enum Sport { 
  baseball(displayName: "Baseball", assetPath: "assets/sports/baseball.png"),
  basketBall(displayName: "Basketball", assetPath: "assets/sports/basketball.png"),
  crossCountry(displayName: "Cross Country", assetPath: "assets/sports/cross_country.png"),
  golf(displayName: "Golf", assetPath: "assets/sports/golf.png"),
  lacrosse(displayName: "Lacrosse", assetPath: "assets/sports/lacrosse.png"),
  soccer(displayName: "Soccer", assetPath: "assets/sports/soccer.png"),
  swimDive(displayName: "Swimming & Diving", assetPath: "assets/sports/swimming.png"),
  tennis(displayName: "Tennis", assetPath: "assets/sports/tennis.png"),
  trackField(displayName: "Track & Field", assetPath: "assets/sports/track.png"),
  wrestling(displayName: "Wrestling", assetPath: "assets/sports/wrestling.png"),
  softball(displayName: "Softball", assetPath: "assets/sports/softball.png"),
  volleyball(displayName: "Volleyball", assetPath: "assets/sports/volleyball.png");
  
  final String displayName;
  final String assetPath;
  const Sport({required this.displayName, required this.assetPath});
}
