class Product {
  final String name;
  final String price;
  final String status;
  final String image;
  final String category;

  Product({
    required this.name,
    required this.price,
    required this.status,
    required this.image,
    required this.category,
  });
}

final List<Product> products = [
  Product(
    name: 'Nike Air Max 200',
    price: '180.0',
    status: 'Trending Now',
    image: 'assets/AirMax.png',
    category: 'Sneakers',
  ),
  Product(
    name: 'Nike Originals',
    price: '120.0',
    status: 'Out of Stock',
    image: 'assets/NikeOriginal.png',
    category: 'Sneakers',
  ),
  Product(
    name: 'Adidas Hoodie Jacket',
    price: '90.0',
    status: 'Trending Now',
    image: 'assets/Addidas.png',
    category: 'Jackets',
  ),
  Product(
    name: 'Leather Jacket',
    price: '130.0',
    status: 'Out of Stock',
    image: 'assets/LeatherJaccket.png',
    category: 'Jackets',
  ),
];
