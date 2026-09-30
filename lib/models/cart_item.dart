class CartItem {
  final int? id;
  final int productId;
  final String name;
  final int price;
  final String image;
  int quantity;

  CartItem({
    this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
  });

  // Mengubah data SQLite menjadi object CartItem
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      productId: map['product_id'],
      name: map['name'],
      price: map['price'],
      image: map['image'] ?? '',
      quantity: map['quantity'],
    );
  }

  // Mengubah object CartItem menjadi data SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }

  // Menghitung subtotal
  int get subtotal => price * quantity;
}