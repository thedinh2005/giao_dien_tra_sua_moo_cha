import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/order_model.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  final List<CartItem> cartList; // Danh sách sản phẩm trong giỏ
  final Function refresh; // Hàm refresh từ main.dart
  final Function(Order)? onOrderCreated; // Thêm callback để lưu đơn hàng

  const CartPage({
    super.key,
    required this.cartList, // Danh sách sản phẩm trong giỏ
    required this.refresh, // Hàm refresh từ main.dart
    this.onOrderCreated, // Optional parameter
  });

  @override
  State<CartPage> createState() => _CartPageState(); // Stateful để cập nhật giao diện khi xóa sản phẩm
}

class _CartPageState extends State<CartPage> { // Stateful để cập nhật giao diện khi xóa sản phẩm
  double get totalPrice => // Tính tổng giá trị đơn hàng
      widget.cartList.fold(0, (sum, item) => sum + item.getTotalPrice()); // Sử dụng fold để tính tổng giá trị đơn hàng

  void _showEditDialog(CartItem item, int index) {
    // Tạo bản sao để chỉnh sửa
    int tempQuantity = item.quantity;
    Option? tempSelectedSize = item.selectedSize;
    List<Option> tempSelectedToppings = List.from(item.selectedToppings);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Chỉnh sửa: ${item.drink.name}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Số lượng
                    Row(
                      children: [
                        const Text('Số lượng: '),
                        IconButton(
                          onPressed: tempQuantity > 1 ? () {
                            setDialogState(() {
                              tempQuantity--;
                            });
                          } : null,
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text('$tempQuantity', style: const TextStyle(fontSize: 16)),
                        IconButton(
                          onPressed: () {
                            setDialogState(() {
                              tempQuantity++;
                            });
                          },
                          icon: const Icon(Icons.add_circle_outline, color: Colors.red),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Size
                    if (item.drink.sizes.isNotEmpty) ...[
                      const Text('Chọn size:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Column(
                        children: item.drink.sizes.map((size) {
                          return RadioListTile<Option>(
                            contentPadding: EdgeInsets.zero,
                            title: Text('${size.name} (+${size.extraPrice.toStringAsFixed(0)}đ)'),
                            value: size,
                            groupValue: tempSelectedSize,
                            onChanged: (Option? value) {
                              setDialogState(() {
                                tempSelectedSize = value;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // Toppings
                    if (item.drink.toppings.isNotEmpty) ...[
                      const Text('Chọn topping:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Column(
                        children: item.drink.toppings.map((topping) {
                          return CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('${topping.name} (+${topping.extraPrice.toStringAsFixed(0)}đ)'),
                            value: tempSelectedToppings.contains(topping),
                            onChanged: (bool? value) {
                              setDialogState(() {
                                if (value == true) {
                                  if (!tempSelectedToppings.contains(topping)) {
                                    tempSelectedToppings.add(topping);
                                  }
                                } else {
                                  tempSelectedToppings.remove(topping);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                    
                    const SizedBox(height: 16),
                    // Hiển thị giá tạm tính
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tạm tính:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            '${_calculateTempPrice(item.drink, tempQuantity, tempSelectedSize, tempSelectedToppings).toStringAsFixed(0)}đ',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Tạo CartItem mới với thông tin cập nhật
                      widget.cartList[index] = CartItem(
                        drink: item.drink,
                        quantity: tempQuantity,
                        selectedSize: tempSelectedSize,
                        selectedToppings: tempSelectedToppings,
                      );
                    });
                    widget.refresh();
                    Navigator.of(context).pop();
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã cập nhật ${item.drink.name}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Cập nhật'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Hàm tính giá tạm thời để hiển thị trong dialog
  double _calculateTempPrice(Drink drink, int quantity, Option? selectedSize, List<Option> selectedToppings) {
    double total = drink.basePrice;
    if (selectedSize != null) {
      total += selectedSize.extraPrice;
    }
    for (var topping in selectedToppings) {
      total += topping.extraPrice;
    }
    return total * quantity;
  }

  @override
  Widget build(BuildContext context) { // Giao diện chính của trang giỏ hàng
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giỏ hàng"),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: widget.cartList.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("Giỏ hàng trống", style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: widget.cartList.length,
              itemBuilder: (context, index) {
                final item = widget.cartList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Hình ảnh sản phẩm
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            item.drink.image, 
                            width: 60, 
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // Thông tin sản phẩm
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.drink.name,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.getOptionsDescription(),
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Text("Số lượng: ${item.quantity}"),
                              const SizedBox(height: 4),
                              Text(
                                "${item.getTotalPrice().toStringAsFixed(0)}đ",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Nút hành động
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                              onPressed: () {
                                _showEditDialog(item, index);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                              onPressed: () {
                                setState(() {
                                  widget.cartList.removeAt(index);
                                });
                                widget.refresh();
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Đã xóa ${item.drink.name} khỏi giỏ hàng'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: widget.cartList.isEmpty ? null : Container( // Thanh toán
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tổng cộng (${widget.cartList.length} món):",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  "${totalPrice.toStringAsFixed(0)}đ",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutPage(
                      cartList: widget.cartList,
                      totalPrice: totalPrice,
                      onOrderCreated: widget.onOrderCreated, // Truyền callback
                      onOrderComplete: () {
                        // Xóa tất cả sản phẩm trong giỏ hàng
                        setState(() {
                          widget.cartList.clear();
                        });
                        widget.refresh();
                      },
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text("Thanh toán", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}