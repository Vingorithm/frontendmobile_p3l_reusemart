// lib/services/navigation_helper.dart
import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(0);
  static final ValueNotifier<String> roleNotifier = ValueNotifier<String>("Guest");

  static void updateSelectedIndex(int index) {
    selectedIndexNotifier.value = index;
  }

  static void updateRole(String role) {
    roleNotifier.value = role;
  }

  static void navigateToPage(Widget page, {int? navBarIndex}) {
    if (navBarIndex != null) {
      selectedIndexNotifier.value = navBarIndex;
    }
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static void navigateAndReplace(Widget page, {int? navBarIndex}) {
    if (navBarIndex != null) {
      selectedIndexNotifier.value = navBarIndex;
    }
    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static void goBack() {
    navigatorKey.currentState?.pop();
  }

  static List<Map<String, dynamic>> getNavItemsByRole(String role) {
    switch (role) {
      case 'Pembeli':
        return [
          {'icon': Icons.home_outlined, 'label': 'Home', 'route': '/home'},
          {'icon': Icons.shopping_cart_outlined, 'label': 'Merchandise', 'route': '/merchandise'},
          {'icon': Icons.receipt_long_outlined, 'label': 'Transaksi', 'route': '/transaksi'},
          {'icon': Icons.person_outline, 'label': 'Profile', 'route': '/profile'},
        ];
      case 'Penitip':
        return [
          {'icon': Icons.home_outlined, 'label': 'Home', 'route': '/home'},
          {'icon': Icons.receipt_long_outlined, 'label': 'Transaksi', 'route': '/transaksi'},
          {'icon': Icons.person_outline, 'label': 'Profile', 'route': '/profile'},
        ];
      case 'Kurir':
        return [
          {'icon': Icons.home_outlined, 'label': 'Home', 'route': '/home'},
          {'icon': Icons.task_alt_outlined, 'label': 'Tugas', 'route': '/tugas'},
          {'icon': Icons.person_outline, 'label': 'Profile', 'route': '/profile'},
        ];
      case 'Hunter':
        return [
          {'icon': Icons.home_outlined, 'label': 'Home', 'route': '/home'},
          {'icon': Icons.attach_money_outlined, 'label': 'Komisi', 'route': '/komisi'},
          {'icon': Icons.person_outline, 'label': 'Profile', 'route': '/profile'},
        ];
      default:
        return [
          {'icon': Icons.home_outlined, 'label': 'Home', 'route': '/home'},
          {'icon': Icons.person_outline, 'label': 'Profile', 'route': '/profile'},
        ];
    }
  }
}