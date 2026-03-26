class OrderProductModel {
  final int id;
  final String title;
  final double price;
  final int quantity;
  final double total;
  final String thumbnail;

  OrderProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.total,
    required this.thumbnail,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      id: json['id'],
      title: json['title'] ?? "",
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] ?? 0,
      total: (json['total'] as num).toDouble(),
      thumbnail: json['thumbnail']?.toString() ?? "",
    );
  }
}

class OrderModel {
  final int id;
  final double total;
  final int totalProducts;
  final int totalQuantity;
  final List<OrderProductModel> products;
  final DateTime date;

  String status;

  OrderModel({
    required this.id,
    required this.total,
    required this.totalProducts,
    required this.totalQuantity,
    required this.products,
    required this.date,
    required this.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      total: (json['total'] as num).toDouble(),
      totalProducts: json['totalProducts'],
      totalQuantity: json['totalQuantity'],
      products: (json['products'] as List)
          .map((e) => OrderProductModel.fromJson(e))
          .toList(),
      //DATE
     date: DateTime.now().subtract(
        Duration(days: json['id'] % 30),
      ),

    //STATUS
   status: (json['status'] ?? "pending").toString().toLowerCase(),
  );
}
}