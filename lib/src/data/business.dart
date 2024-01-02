class Business {
  late final String id;
  final String name;
  final String email;
  final String industry;
  final String location;
  final String socialMediaLink;
  final String? website;
  
  final String logoUrl;
  final String? productImageUrl;
  final List<String> additionalImageUrls;

  Business({
    required this.name,
    required this.email,
    required this.industry,
    required this.location,
    required this.socialMediaLink,
    required this.website,
    required this.logoUrl,
    required this.productImageUrl,
    required this.additionalImageUrls,
  });
}
