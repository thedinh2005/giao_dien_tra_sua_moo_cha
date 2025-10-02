import 'package:flutter/material.dart';
import 'help_page.dart';
import 'orders_page.dart';
import '../models/order_model.dart';

class ProfilePage extends StatelessWidget {
  final List<Order> orderHistory;

  const ProfilePage({super.key, required this.orderHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 247, 236),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 247, 236),
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔹 Header user info
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("assets/avatar.jpg"),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, Thanh Phong",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "thanhphongduong1086@gmail.com",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.grey),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 Upgrade card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Starter Plan",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text("All features unlocked!",
                            style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Upgrade"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Sections
            buildSectionTitle("Account"),
            buildMenuItem(
              Icons.shopping_bag_outlined, 
              "Orders", 
              trailing: orderHistory.isNotEmpty ? "${orderHistory.length}" : null,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrdersPage(orderHistory: orderHistory),
                  ),
                );
              },
            ),
            buildMenuItem(Icons.favorite_border, "Wishlist"),
            buildMenuItem(Icons.payment, "Payment"),
            buildMenuItem(Icons.account_balance_wallet_outlined, "Wallet"),

            buildSectionTitle("Personalization"),
            buildMenuItem(Icons.notifications_none, "Notification", trailing: "Off"),
            buildMenuItem(Icons.settings_suggest_outlined, "Preferences"),

            buildSectionTitle("Settings"),
            buildMenuItem(Icons.language, "Language"),
            buildMenuItem(Icons.location_city_outlined, "Location"),

            buildSectionTitle("Help & Support"),
            buildMenuItem(Icons.help_outline, "Get Help", onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpPage()),
              );
            }),
            buildMenuItem(Icons.question_answer_outlined, "FAQ"),

            const SizedBox(height: 16),

            // 🔹 Log out
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Log Out",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () {
                // TODO: handle logout
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget tiêu đề section
  Widget buildSectionTitle(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
      ),
    );
  }

  // Widget menu item, có onTap tuỳ chọn
  Widget buildMenuItem(IconData icon, String title,
      {String? trailing, VoidCallback? onTap}) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailing != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  trailing, 
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (trailing != null) const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
        onTap: onTap ?? () {},
      ),
    );
  }
}