import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trợ Giúp & Hỗ Trợ"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Bạn cần hỗ trợ?",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Nếu bạn có bất kỳ câu hỏi hoặc vấn đề nào, bạn có thể liên hệ với đội ngũ hỗ trợ của chúng tôi, "
            "duyệt qua các câu hỏi thường gặp (FAQ), hoặc kiểm tra các hướng dẫn dưới đây.",
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 24),

          // Các chủ đề hỗ trợ ví dụ
          buildHelpCard(
            context,
            "FAQ",
            "Các câu hỏi thường gặp",
            Icons.question_answer,
            onTap: () {
              // TODO: Mở trang FAQ
            },
          ),
          buildHelpCard(
            context,
            "Liên hệ Hỗ trợ",
            "Liên hệ với đội ngũ hỗ trợ của chúng tôi",
            Icons.support_agent,
            onTap: () {
              // TODO: Mở trang liên hệ hỗ trợ
            },
          ),
          buildHelpCard(
            context,
            "Hướng dẫn",
            "Hướng dẫn từng bước",
            Icons.video_library,
            onTap: () {
              // TODO: Mở trang hướng dẫn
            },
          ),
        ],
      ),
    );
  }

  // Widget cho từng thẻ chủ đề hỗ trợ
  Widget buildHelpCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurpleAccent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
