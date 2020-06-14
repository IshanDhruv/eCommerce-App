class Product {
  final String id;
  final String name;
  final String color;
  final double price;
  final String brand;
  final String gender;

  Product({this.id, this.name, this.color, this.brand, this.price, this.gender});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id:json["id"].toString(),
      name: json["name"],
      color: json["colour"],
      brand: json["brand"],
      price: json["price"].toDouble(),
      gender: json["gender"] ?? "Unisex"
    );
  }

  factory Product.fromJsonList(List<dynamic> json) {
    return Product(
        id:json[0]["id"].toString(),
        name: json[0]["name"],
        color: json[0]["colour"],
        brand: json[0]["brand"],
        price: json[0]["price"].toDouble(),
        gender: json[0]["gender"] ?? "Unisex"
    );
  }
}
