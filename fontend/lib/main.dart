import 'package:flutter/material.dart';
import 'home/home_page.dart';
import 'models/category.dart';
import 'models/order_model.dart';
import 'home/splash_screen.dart'; // đặt splash trong thư mục home như bạn đang dùng
import 'home/login_page.dart'; // login_page.dart ở lib/

void main() {
  runApp(const HappyFruitApp());
}

class HappyFruitApp extends StatefulWidget {
  const HappyFruitApp({super.key});

  @override
  State<HappyFruitApp> createState() => _HappyFruitAppState();
}

class _HappyFruitAppState extends State<HappyFruitApp> {
  // Navigator key để gọi navigation từ bên ngoài context của MaterialApp
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  // State toàn app (giữ nguyên như bạn yêu cầu)
  List<CartItem> cartList = [];
  List<Order> orderHistory = [];
  List<Drink> favoriteList = [];

  // Thêm đơn hàng vào lịch sử
  void addOrderToHistory(Order order) {
    setState(() {
      orderHistory.insert(0, order);
    });
  }

  // Refresh toàn app
  void refreshApp() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navKey, // đăng ký navigatorKey ở đây
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Roboto',
      ),

      // Start app from SplashScreen. Khi splash kết thúc, mình sẽ dùng _navKey để điều hướng.
      home: SplashScreen(
        onSplashComplete: () {
          // Dùng navigatorKey để push LoginPage (không dùng context của this State).
          _navKey.currentState?.pushReplacement(
            MaterialPageRoute(
              builder: (_) => LoginPage(
                onLoginSuccess: () {
                  // Sau khi login thành công, chuyển tiếp sang HappyFruitHomePage
                  _navKey.currentState?.pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => HappyFruitHomePage(
                        cartList: cartList,
                        favoriteList: favoriteList,
                        orderHistory: orderHistory,
                        refresh: refreshApp,
                        onOrderCreated: addOrderToHistory,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
