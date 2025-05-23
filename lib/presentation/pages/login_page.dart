// lib/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/theme/color_pallete.dart';
import '../../core/theme/app_theme.dart';
import '../../data/services/akun_service.dart';
import '../../data/services/auth_service.dart';
import '../../utils/tokenUtils.dart';
import '../../utils/notification_service.dart';
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
  final AuthService _apiService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Validasi input
      if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
        ToastUtils.showWarning(context, 'Form login tidak boleh kosong!');
        return;
      }

      // Validasi format email basic
      if (!_emailController.text.contains('@')) {
        ToastUtils.showWarning(context, 'Format email tidak valid!');
        return;
      }

      // Panggil API login
      final response = await _apiService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (response['token'] != null && response['akun'] != null) {
        // Simpan JWT token ke SharedPreferences
        await saveToken(response['token']);
        
        // Kirim FCM token ke backend setelah login berhasil
        String userId = response['akun']['id_akun'];
        bool fcmSent = await NotificationService.sendFcmTokenToBackend(userId);
        
        if (fcmSent) {
          print('FCM token sent successfully after login');
        } else {
          print('Failed to send FCM token, but login still successful');
        }

        // Show success toast
        ToastUtils.showSuccess(context, 'Login berhasil!');
        
        // Navigate setelah delay
        await Future.delayed(const Duration(milliseconds: 1500));
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const RootScreen()),
          );
        }
      } else {
        ToastUtils.showError(
          context, 
          response['message'] ?? 'Login gagal, silakan coba lagi'
        );
      }
    } catch (e) {
      String errorMessage = 'Terjadi kesalahan saat login';
      
      // Handle specific error messages
      if (e.toString().contains('Email tidak ditemukan')) {
        errorMessage = 'Email tidak terdaftar';
      } else if (e.toString().contains('Password salah')) {
        errorMessage = 'Password yang Anda masukkan salah';
      } else if (e.toString().contains('Koneksi gagal')) {
        errorMessage = 'Periksa koneksi internet Anda';
      }
      
      ToastUtils.showError(context, errorMessage);
      print('Login error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),

            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _login(), // Login ketika enter ditekan
              decoration: const InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
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
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
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