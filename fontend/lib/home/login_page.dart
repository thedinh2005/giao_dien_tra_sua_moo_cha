import 'package:flutter/material.dart';
//import trang đăng ký ở đây
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginPage({super.key, required this.onLoginSuccess});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng nhập")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey, // form để validate
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset('assets/logo_1.png', width: 300, height: 300),
                const SizedBox(height: 20),

                const Text(
                  "Đăng nhập vào MooCha",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),

                // Trường nhập số điện thoại
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Số điện thoại",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập số điện thoại";
                    }
                    // Regex: bắt đầu bằng 0, đủ 10 số
                    if (!RegExp(r'^0\d{9}$').hasMatch(value)) {
                      return "Số điện thoại không hợp lệ";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Trường nhập mật khẩu
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Mật khẩu",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập mật khẩu";
                    }
                    if (value.length < 8) {
                      return "Mật khẩu phải có ít nhất 8 ký tự";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Nút đăng nhập
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Nếu form hợp lệ thì gọi callback
                      widget.onLoginSuccess();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                  ),
                  child: const Text(
                    "Đăng nhập",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 16),
                //tạo một liên kết như link đăng ký chuyển qua trang nếu chưa có tài khoản
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RegisterPage(
                          onRegisterSuccess: () {
                            // Khi đăng ký thành công → quay lại LoginPage
                            Navigator.pop(context);

                            // Có thể show thông báo ở LoginPage
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Đăng ký thành công, hãy đăng nhập!",
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Chưa có tài khoản? Đăng ký",
                    style: TextStyle(
                      color: Colors.blue, // giống liên kết
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline, // gạch dưới
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
