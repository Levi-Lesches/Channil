enum DealCategory {
  athleticGear(displayName: "Athletic Gear", imageUrl: "https://picsum.photos/200"),
  flowers(displayName: "Flowers", imageUrl: "https://picsum.photos/200"),
  product(displayName: "Product", imageUrl: "https://picsum.photos/200"),
  niche(displayName: "Niche", imageUrl: "https://picsum.photos/200"),
  clothing(displayName: "Clothing", imageUrl: "https://picsum.photos/200"),
  lifestyle(displayName: "Lifestyle", imageUrl: "https://picsum.photos/200");
  
  final String displayName;
  final String imageUrl;
  const DealCategory({
    required this.displayName,
    required this.imageUrl,
  });
}
