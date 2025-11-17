import 'package:flutter/material.dart';
import 'package:task_8/models/product_model.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int selectedIndex = 0;
  int currentNavIndex = 0;
  Set<Product> favoriteProducts = {};
  List<Product> cart = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mantilla E-Commerce App"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: currentNavIndex == 0
    ? _buildHome()
    : currentNavIndex == 1
        ? _buildFavorites()
        : _buildCart(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentNavIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            currentNavIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
        ],
      ),
    );
  }

    Widget _buildCart() {
    if (cart.isEmpty) {
      return const Center(child: Text("Your cart is empty."));
    }

    double total = 0;
    for (var item in cart) {
      total += double.parse(item.price) * item.quantity;
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cart.length,
            itemBuilder: (context, index) {
              final product = cart[index];
              return ListTile(
                leading: Image.asset(product.image, width: 50),
                title: Text(product.name),
                subtitle: Text("₱${product.price} x ${product.quantity}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() => cart.removeAt(index));
                  },
                ),
              );
            },
          ),
        ),

        // CHECKOUT SECTION
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                "Total: ₱${total.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    cart.clear();
                  });

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Checkout Complete!"),
                      content: const Text("Thank you for your purchase."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 12
                  ),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Checkout"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Our Products",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _categoryButton("All Products", 0),
            _categoryButton("Jackets", 1),
            _categoryButton("Sneakers", 2),
          ],
        ),
        const SizedBox(height: 15),
        Expanded(child: _buildProductGrid()),
      ],
    );
  }

  Widget _buildProductGrid() {
    List<Product> displayProducts;

    if (selectedIndex == 0) {
      displayProducts = products;
    } else if (selectedIndex == 1) {
      displayProducts = products
          .where((product) => product.category == 'Jackets')
          .toList();
    } else {
      displayProducts = products
          .where((product) => product.category == 'Sneakers')
          .toList();
    }

    return GridView.builder(
      itemCount: displayProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final product = displayProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _categoryButton(String title, int index) {
    return ElevatedButton(
      onPressed: () => setState(() => selectedIndex = index),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedIndex == index ? Colors.red : Colors.grey[200],
        foregroundColor: selectedIndex == index ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(title),
    );
  }

  Widget _buildFavorites() {
    if (favoriteProducts.isEmpty) {
      return const Center(child: Text("No favorite products yet."));
    }

    return GridView.builder(
      itemCount: favoriteProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final product = favoriteProducts.elementAt(index);
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Product product) {
    final isFavorited = favoriteProducts.contains(product);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    if (isFavorited) {
                      favoriteProducts.remove(product);
                    } else {
                      favoriteProducts.add(product);
                    }
                  });
                },
              ),
            ),
            Expanded(child: Image.asset(product.image, fit: BoxFit.contain)),
            const SizedBox(height: 8),
            Text(
              product.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(product.status),
            Text(
              "\$${product.price}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // ADD TO CART BUTTON
            ElevatedButton(
              onPressed: () {
                setState(() {
                  cart.add(product);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${product.name} added to cart!"),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text("Add to Cart"),
            ),

          ],
        ),
      ),
    );
  }
}
