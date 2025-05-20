import 'package:flutter/material.dart';
import '../../core/theme/color_pallete.dart';
import 'login_page.dart'; // Pastikan ada file ini

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  String selectedRole = 'Pembeli';
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void register() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'role': selectedRole,
        'username': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'alamat': selectedRole == 'Organisasi Amal' ? alamatController.text : null,
      };

      // TODO: Ganti dengan pemanggilan API-mu
      print("Mendaftarkan dengan data: $data");

      // Tampilkan snackbar / redirect
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Berhasil mendaftar!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Logo
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Reuse ',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'Mart',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            backgroundColor: Colors.green,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Register",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Dropdown Role
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Role',
                    ),
                    items: ['Pembeli', 'Organisasi Amal'].map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Username
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Username wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),

                  // Alamat (hanya untuk organisasi)
                  if (selectedRole == 'Organisasi Amal')
                    Column(
                      children: [
                        TextFormField(
                          controller: alamatController,
                          decoration: const InputDecoration(
                            labelText: "Alamat",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => selectedRole == 'Organisasi Amal' && value!.isEmpty
                              ? 'Alamat wajib diisi'
                              : null,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),

                  // Email
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "@email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Email wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.length < 6 ? 'Minimal 6 karakter' : null,
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Konfirmasi Password",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value != passwordController.text
                        ? 'Password tidak cocok'
                        : null,
                  ),
                  const SizedBox(height: 24),

                  // Tombol Register
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Navigasi ke Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Sudah punya akun? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text(
                          "login",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
