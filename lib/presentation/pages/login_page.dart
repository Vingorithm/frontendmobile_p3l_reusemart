import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../core/theme/color_pallete.dart';
import '../../core/theme/app_theme.dart';

import '../../data/api_service.dart';
import '../../utils/tokenUtils.dart';
import '../../presentation/widgets/toast_universal.dart';

import './register_page.dart';
import './home_page.dart';
import '../../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ApiService _apiService = ApiService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_emailController.text.length == 0 ||
          _passwordController.text.length == 0) {
        // Show warning toast for empty fields
        ToastUtils.showWarning(context, 'Form login tidak boleh kosong!');
      } else {
        final response = await _apiService.login(
            _emailController.text, _passwordController.text);

        if (response['token'] != null) {
          // Show success toast
          ToastUtils.showSuccess(context, 'Login berhasil!');
          
          saveToken(response['token']);
          
          // Delay navigation to show toast
          Future.delayed(const Duration(milliseconds: 1500), () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => RootScreen()));
          });
        } else {
          // Show error toast for login failure
          ToastUtils.showError(
              context, response['message'] ?? 'Login gagal, silakan coba lagi');
        }
      }
    } catch (e) {
      // Show error toast for exceptions
      ToastUtils.showError(context, 'Terjadi kesalahan: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),

            // Logo ReuseMart
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const RootScreen()),
                );
              },
              child: Image.asset(
                'assets/images/logo.png',
                height: 90,
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'Login',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 32),

            // Email Field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  // Show info toast for forgot password
                  ToastUtils.showInfo(context, 'Fitur lupa password akan segera hadir!');
                },
                child: const Text(
                  'lupa password?',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Login Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Login',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Belum punya akun?',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    'register',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}