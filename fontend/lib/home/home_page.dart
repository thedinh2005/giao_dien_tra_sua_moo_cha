import 'package:flutter/material.dart';
import 'product_detail_page.dart';
import '../models/category.dart';
import '../models/order_model.dart';
import '../widgets/banner.dart';
import 'profile_page.dart';
import 'cart_page.dart';

final List<Drink> bestSellerProducts = [
  products[0],
  products[1],
  products[3],
];

class HappyFruitHomePage extends StatefulWidget {
  final List<CartItem> cartList;
  final List<Drink> favoriteList;
  final List<Order> orderHistory;
  final Function refresh;
  final Function(Order) onOrderCreated;

  const HappyFruitHomePage({
    super.key,
    required this.cartList,
    required this.favoriteList,
    required this.orderHistory,
    required this.refresh,
    required this.onOrderCreated,
  });

  @override
  State<HappyFruitHomePage> createState() => _HappyFruitHomePageState();
}

class _HappyFruitHomePageState extends State<HappyFruitHomePage> {
  String selectedCategory = "";
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Drink> filteredProducts =
        products.where((p) => p.category == selectedCategory).toList();

    final List<Widget> pages = [
      buildHome(filteredProducts),
      buildFavoritePage(),
      CartPage(
        cartList: widget.cartList,
        onOrderCreated: widget.onOrderCreated,
        refresh: widget.refresh,
      ),
      ProfilePage(orderHistory: widget.orderHistory),
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 247, 236),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 247, 236),
        elevation: 0,
        title: Row(
          children: [
            Flexible(
              child: Image.asset(
                "assets/logo_1.png",
                height: 140,
                width: 140,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {
              setState(() {
                _selectedIndex = 3;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 253, 61, 61),
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Yêu thích"),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart),
                if (widget.cartList.isNotEmpty)
                  Positioned(
                    right: -8,
                    top: -8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${widget.cartList.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: "Giỏ hàng",
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.person),
                if (widget.orderHistory.isNotEmpty)
                  Positioned(
                    right: -8,
                    top: -8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${widget.orderHistory.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  /// Trang Home
  Widget buildHome(List<Drink> filteredProducts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔍 Thanh search
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Hôm nay bạn tìm gì?",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        // 📜 Nội dung chính
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BannerWidget(),
                const SizedBox(height: 20),
                // Danh mục
                SizedBox(
                  height: 90,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      buildCategory(Icons.emoji_food_beverage, "Trà sữa"),
                      buildCategory(Icons.coffee, "Cà phê"),
                      buildCategory(Icons.local_drink, "Nước ép"),
                      buildCategory(Icons.local_cafe, "Sinh tố"),
                      buildCategory(Icons.fastfood, "Ăn vặt"),
                    ],
                  ),
                ),
                // Nếu chưa chọn danh mục thì hiển thị best seller
                if (selectedCategory.isEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Text("Sản phẩm phổ biến",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 3 / 4,
                    children: bestSellerProducts.map(buildProduct).toList(),
                  ),
                ],
                // Nếu chọn danh mục thì hiển thị sản phẩm theo danh mục
                if (selectedCategory.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Text(selectedCategory,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 3 / 4,
                    children: filteredProducts.map(buildProduct).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Trang Yêu thích
  Widget buildFavoritePage() {
    if (widget.favoriteList.isEmpty) {
      return const Center(child: Text("Chưa có sản phẩm yêu thích"));
    }
    return ListView.builder(
      itemCount: widget.favoriteList.length,
      itemBuilder: (context, index) {
        final drink = widget.favoriteList[index];
        return ListTile(
          leading: Image.asset(drink.image, height: 50),
          title: Text(drink.name),
          subtitle: Text(drink.price),
        );
      },
    );
  }

  /// Widget nút danh mục
  Widget buildCategory(IconData icon, String title) {
    bool isSelected = selectedCategory == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedCategory = "";
          } else {
            selectedCategory = title;
          }
        });
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 32, color: isSelected ? Colors.orange : Colors.grey),
            const SizedBox(height: 8),
            Text(title,
                style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? Colors.orange : Colors.black)),
          ],
        ),
      ),
    );
  }

  /// Widget hiển thị sản phẩm
  Widget buildProduct(Drink drink) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              drink: drink,
              cartList: widget.cartList,
              favoriteList: widget.favoriteList,
              refresh: widget.refresh,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(drink.image,
                    fit: BoxFit.contain, width: double.infinity),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(drink.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(drink.price,
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
