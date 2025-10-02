import 'package:flutter/material.dart';
import '../models/category.dart';

class ProductDetailPage extends StatefulWidget {
  final Drink drink;
  final List<CartItem> cartList;
  final List<Drink> favoriteList;
  final Function refresh;

  const ProductDetailPage({
    super.key,
    required this.drink,
    required this.cartList,
    required this.favoriteList,
    required this.refresh,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;
  Option? selectedSize;
  List<Option> selectedToppings = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Chi tiết sản phẩm",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.favoriteList.contains(widget.drink)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () {
              setState(() {
                if (widget.favoriteList.contains(widget.drink)) {
                  widget.favoriteList.remove(widget.drink);
                } else {
                  widget.favoriteList.add(widget.drink);
                }
              });
              widget.refresh();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  widget.drink.image,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Thông tin
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.drink.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 18),
                      const SizedBox(width: 4),
                      Text("${widget.drink.rating} | Đã bán 120+",
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(widget.drink.price,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                ],
              ),
            ),

            // Size
            if (widget.drink.sizes.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 8),
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Chọn size",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    ...widget.drink.sizes.map((size) {
                      return RadioListTile<Option>(
                        title: Text(
                            "${size.name} (+${size.extraPrice.toStringAsFixed(0)}đ)"),
                        value: size,
                        groupValue: selectedSize,
                        onChanged: (value) {
                          setState(() => selectedSize = value);
                        },
                      );
                    }),
                  ],
                ),
              ),

            // Topping
            if (widget.drink.toppings.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 8),
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Chọn topping",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    ...widget.drink.toppings.map((topping) {
                      final isSelected = selectedToppings.contains(topping);
                      return CheckboxListTile(
                        title: Text(
                            "${topping.name} (+${topping.extraPrice.toStringAsFixed(0)}đ)"),
                        value: isSelected,
                        onChanged: (checked) {
                          setState(() {
                            if (checked == true) {
                              selectedToppings.add(topping);
                            } else {
                              selectedToppings.remove(topping);
                            }
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),

            // Số lượng
            Container(
              margin: const EdgeInsets.only(top: 8),
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Số lượng",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (quantity > 1) setState(() => quantity--);
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text("$quantity",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: () => setState(() => quantity++),
                        icon: const Icon(Icons.add_circle_outline),
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),

      // Nút thêm giỏ hàng
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            widget.cartList.add(CartItem(
              drink: widget.drink,
              quantity: quantity,
              selectedSize: selectedSize,
              selectedToppings: List.from(selectedToppings),
            ));
            widget.refresh();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("Đã thêm ${widget.drink.name} vào giỏ hàng")),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text(
  "Thêm vào giỏ hàng",
  style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white, // ✅ đổi chữ thành màu trắng
  ),
),
        ),
      ),
    );
  }
}
