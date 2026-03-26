class Shop {
  final String id;
  final String name;
  final String category;
  final String banner;
  final String logo;

  Shop({
    required this.id,
    required this.name,
    required this.category,
    required this.banner,
    required this.logo,
  });

  /// 🔥 FROM FIRESTORE
  factory Shop.fromMap(Map<String, dynamic> data, String id) {
    return Shop(
      id: id,
      name: data['shopName'] ?? '',
      category: data['category'] ?? '',
      banner: data['banner'] ?? '',
      logo: data['logo'] ?? '',
    );
  }

  /// 🔥 TO FIRESTORE
  Map<String, dynamic> toMap() {
    return {
      'shopName': name,
      'category': category,
      'banner': banner,
      'logo': logo,
    };
  }
}