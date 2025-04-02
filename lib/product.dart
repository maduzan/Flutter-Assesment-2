class Product {
  final int id;
  final String? title;
  final String? description;
  final String? thumbnail;
  final List<String>? images;
  final double? price;
  final String? brand;
  final double? rating;

  Product({
    required this.id,
    this.title,
    this.description,
    this.thumbnail,
    this.images,
    this.price,
    this.brand,
    this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      images: List<String>.from(json['images'] ?? []),
      price: json['price']?.toDouble(),
      brand: json['brand'],
      rating: json['rating']?.toDouble(),
    );
  }
}
