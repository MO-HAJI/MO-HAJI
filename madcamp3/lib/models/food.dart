class FoodInfo {
  final int id;
  final String email;
  final String url;
  final String keyword;
  final String recipe;
  final String allergy;

  FoodInfo({
    required this.id,
    required this.email,
    required this.url,
    required this.keyword,
    required this.recipe,
    required this.allergy,
  });

  factory FoodInfo.fromJson(Map<String, dynamic> json) {
    return FoodInfo(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      url: json['url'] ?? '',
      keyword: json['keyword'] ?? '',
      recipe: json['recipe'] ?? '',
      allergy: json['allergy'] ?? '',
    );
  }
}
