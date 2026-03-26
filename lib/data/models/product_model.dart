class ProductModel {
  final int id;
  final String title;
  final double price;
  final int stock;
  final String thumbnail;
  final String description;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.stock,
    required this.thumbnail,
    required this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'] ?? "",
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] ?? 0,
      thumbnail: json['thumbnail'] ?? "",
      description: json['description'] ?? "",
    );
  }
}