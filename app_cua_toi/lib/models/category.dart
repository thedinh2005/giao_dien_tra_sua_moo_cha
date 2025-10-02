class Option {
  final String name;
  final double extraPrice;

  Option({required this.name, required this.extraPrice});
}

class Drink {
  final String name; // Tên sản phẩm
  final String image; // Hình ảnh
  final String price; // Giá gốc (chuỗi để hiển thị)
  final double rating; // Đánh giá
  final String category; // Danh mục
  final String description; // Mô tả
  final List<Option> sizes; // Danh sách size
  final List<Option> toppings; // Danh sách topping

  Drink({
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    required this.category,
    required this.description,
    this.sizes = const [],
    this.toppings = const [],
  });

  double get basePrice {
    return double.tryParse(price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }
}

class CartItem {
  final Drink drink;
  int quantity;
  final Option? selectedSize;
  final List<Option> selectedToppings;

  CartItem({
    required this.drink,
    this.quantity = 1,
    this.selectedSize,
    this.selectedToppings = const [],
  });

  /// Tính tổng tiền cho sản phẩm
  double getTotalPrice() {
    double total = drink.basePrice;
    if (selectedSize != null) {
      total += selectedSize!.extraPrice;
    }
    for (var topping in selectedToppings) {
      total += topping.extraPrice;
    }
    return total * quantity;
  }

  /// Hiển thị size + topping
  String getOptionsDescription() {
    List<String> options = [];
    if (selectedSize != null) {
      options.add("Size: ${selectedSize!.name}");
    }
    if (selectedToppings.isNotEmpty) {
      options.add("Topping: ${selectedToppings.map((t) => t.name).join(", ")}");
    }
    return options.isNotEmpty ? options.join(" | ") : "Mặc định";
  }
}

final List<Drink> products = [
  Drink(
    name: "Trà sữa truyền thống",
    image: "assets/milktea/tra_sua_truyen_thong.jpg",
    price: "25000 VNĐ",
    rating: 4.9,
    category: "Trà sữa",
    description:
        "Trà sữa truyền thống thơm ngọt, vị trà thanh mát hòa quyện cùng sữa béo ngậy.",
    sizes: [
      Option(name: "M", extraPrice: 0),
      Option(name: "L", extraPrice: 5000),
      Option(name: "XL", extraPrice: 10000),
    ],
    toppings: [
      Option(name: "Trân châu đen", extraPrice: 5000),
      Option(name: "Trân châu trắng", extraPrice: 7000),
      Option(name: "Thạch dừa", extraPrice: 3000),
      Option(name: "Khúc bạch", extraPrice: 5000)
    ],
  ),
  Drink(
    name: "Matcha latte",
    image: "assets/milktea/matcha_latte.jpg",
    price: "25000 VNĐ",
    rating: 4.9,
    category: "Trà sữa",
    description:
        "Trà sữa matcha thơm ngon, vị trà xanh thanh mát hòa quyện cùng sữa béo ngậy.",
    sizes: [
      Option(name: "M", extraPrice: 0),
      Option(name: "L", extraPrice: 7000),
      Option(name: "XL", extraPrice: 12000),
    ],
    toppings: [
      Option(name: "Trân châu đen", extraPrice: 5000),
      Option(name: "Trân châu trắng", extraPrice: 7000),
      Option(name: "Thạch dừa", extraPrice: 3000),
      Option(name: "Khúc bạch", extraPrice: 5000)
    ],
  ),
  Drink(
    name: "Trà sữa Thái xanh",
    image: "assets/milktea/tra_sua_thai_xanh.jpg",
    price: "25000 VNĐ",
    rating: 4.9,
    category: "Trà sữa",
    description:
        "Trà sữa Thái xanh thơm ngon, vị trà xanh thanh mát hòa quyện cùng sữa béo ngậy.",
    sizes: [
      Option(name: "M", extraPrice: 0),
      Option(name: "L", extraPrice: 5000),
      Option(name: "XL", extraPrice: 10000),
    ],
    toppings: [
      Option(name: "Trân châu đen", extraPrice: 5000),
      Option(name: "Trân châu trắng", extraPrice: 7000),
      Option(name: "Thạch dừa", extraPrice: 3000),
      Option(name: "Khúc bạch", extraPrice: 5000)
    ],
  ),
  Drink(
    name: "Cà phê sữa đá",
    image: "assets/coffee/ca_phe_sua_da.jpg",
    price: "20000 VNĐ",
    rating: 4.8,
    category: "Cà phê",
    description: "Cà phê sữa đá đậm đà, giúp tỉnh táo và tràn đầy năng lượng.",
    sizes: [
      Option(name: "M", extraPrice: 0),
      Option(name: "L", extraPrice: 3000),
      Option(name: "XL", extraPrice: 6000),
    ],
    toppings: [
      Option(name: "Ít sữa", extraPrice: 0),
      Option(name: "Nhiều sữa", extraPrice: 0)
    ],
  ),
  Drink(
    name: "Cà phê đá",
    image: "assets/coffee/ca_phe_den_da.jpg",
    price: "20000 VNĐ",
    rating: 4.8,
    category: "Cà phê",
    description: "Cà phê đá đậm đà, giúp tỉnh táo và tràn đầy năng lượng.",
    sizes: [
      Option(name: "M", extraPrice: 0),
      Option(name: "L", extraPrice: 3000),
      Option(name: "XL", extraPrice: 5000),
    ],
    toppings: [
      Option(name: "Không đường", extraPrice: 0),
      Option(name: "Ít đường", extraPrice: 0),
      Option(name: "Nhiều đường", extraPrice: 0)
    ],
  ),
  Drink(
    name: "Cà phê muối",
    image: "assets/coffee/ca_phe_muoi.jpg",
    price: "20000 VNĐ",
    rating: 4.8,
    category: "Cà phê",
    description: "Cà phê muối - vị đắng dịu, thơm nồng, tạo trải nghiệm thưởng thức độc đáo và cân bằng hương vị.",
    sizes: [
      Option(name: "M", extraPrice: 0),
      Option(name: "L", extraPrice: 5000),
      Option(name: "XL", extraPrice: 10000),
    ],
    toppings: [
      Option(name: "Không đường", extraPrice: 0),
      Option(name: "Ít đường", extraPrice: 0),
      Option(name: "Nhiều đường", extraPrice: 0)
    ],
  ),
  Drink(
    name: "Sinh tố bơ",
    image: "assets/sinhto/sinh_to_bo.jpg",
    price: "45000 VNĐ",
    rating: 4.8,
    category: "Sinh tố",
    description: "Sinh tố bơ béo ngậy, bổ dưỡng cho da và tim mạch.",
    sizes: [
      Option(name: "Nhỏ", extraPrice: 0),
      Option(name: "Lớn", extraPrice: 5000),
    ],
    toppings: [
      Option(name: "Sữa đặc", extraPrice: 3000),
      Option(name: "Hạnh nhân", extraPrice: 7000),
    ],
  ),
  Drink(
    name: "Sinh tố xoài",
    image: "assets/sinhto/sinh_to_xoai.jpg",
    price: "45000 VNĐ",
    rating: 4.8,
    category: "Sinh tố",
    description: "Sinh tố xoài thơm ngon, bổ dưỡng cho sức khỏe.",
    sizes: [
      Option(name: "Nhỏ", extraPrice: 0),
      Option(name: "Lớn", extraPrice: 5000),
    ],
    toppings: [
      Option(name: "Sữa đặc", extraPrice: 3000),
      Option(name: "Hạnh nhân", extraPrice: 7000),
    ],
  ),
];
