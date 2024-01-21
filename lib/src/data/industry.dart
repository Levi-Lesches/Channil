enum Industry {
  athleticGear(displayName: "Athletic Gear", assetPath: "assets/categories/athletic_gear.png"),
  fashion(displayName: "Fashion", assetPath: "assets/categories/fashion.png"),
  tech(displayName: "Tech", assetPath: "assets/categories/tech.png"),
  healthWellness(displayName: "Health & Wellness", assetPath: "assets/categories/health_wellness.png"),
  homeGoods(displayName: "Home Goods", assetPath: "assets/categories/home_goods.png"),
  food(displayName: "Food", assetPath: "assets/categories/food.png"),
  education(displayName: "Education", assetPath: "assets/categories/education.png"),
  lifestyle(displayName: "Lifestyle", assetPath: "assets/categories/lifestyle.png"),
  other(displayName: "Other");
  
  final String displayName;
  final String? assetPath;
  const Industry({
    required this.displayName,
    this.assetPath,
  });
}
