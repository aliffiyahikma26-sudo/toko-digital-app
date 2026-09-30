class Product {
  final int? id;
  final String name;
  final int price;
  final String image;
  final String description;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
  });

  // Mengubah data SQLite menjadi object Product.
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      image: map['image'] ?? '',
      description: map['description'] ?? '',
    );
  }

  // Mengubah object Product menjadi data SQLite.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'description': description,
    };
  }
}