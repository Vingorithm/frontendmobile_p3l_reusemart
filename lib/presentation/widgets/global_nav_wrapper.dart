// lib/presentation/widgets/global_nav_wrapper.dart
import 'package:flutter/material.dart';
import 'navigation_helper.dart';
import '../../core/theme/color_pallete.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/profile_page.dart';
import '../../presentation/pages/merchandise_page.dart';
import '../../presentation/pages/histori_pembelian_page.dart';
import '../../presentation/pages/histori_penitipan_page.dart';
import '../../presentation/pages/histori_tugas_page.dart';
import '../../presentation/pages/histori_komisi_page.dart';
import 'persistent_navbar.dart';

class GlobalNavWrapper extends StatelessWidget {
  final Widget child;
  final bool showNavBar;

  const GlobalNavWrapper({
    super.key,
    required this.child,
    this.showNavBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: NavigationService.roleNotifier,
      builder: (context, role, _) {
        if (!showNavBar || role == "Guest") {
          return child;
        }

        return Scaffold(
          body: child,
          bottomNavigationBar: ValueListenableBuilder<int>(
            valueListenable: NavigationService.selectedIndexNotifier,
            builder: (context, selectedIndex, _) {
              return PersistentBottomNavBar(
                selectedIndex: selectedIndex,
                onItemSelected: _onNavItemSelected,
                role: role,
              );
            },
          ),
        );
      },
    );
  }

  void _onNavItemSelected(int index) {
    NavigationService.updateSelectedIndex(index);
    
    final role = NavigationService.roleNotifier.value;
    final navItems = NavigationService.getNavItemsByRole(role);
    
    if (index < navItems.length) {
      final route = navItems[index]['route'];
      _navigateToRoute(route);
    }
  }

  void _navigateToRoute(String route) {
    Widget destination;
    
    switch (route) {
      case '/home':
        destination = const HomeScreen();
        break;
      case '/merchandise':
        destination = const MerchandiseScreen();
        break;
      case '/transaksi':
        final role = NavigationService.roleNotifier.value;
        if (role == 'Pembeli') {
          destination = const HistoriPembelianPage();
        } else if (role == 'Penitip') {
          destination = const HistoriPenitipanPage();
        } else {
          destination = const HomeScreen();
        }
        break;
      case '/tugas':
        destination = const HistoriTugasPage();
        break;
      case '/komisi':
        destination = const HistoryKomisiDetailPage();
        break;
      case '/profile':
        destination = const ProfileScreen();
        break;
      default:
        destination = const HomeScreen();
    }

    // Navigate to the destination
    Navigator.of(NavigationService.navigatorKey.currentContext!)
        .pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => destination),
      (route) => false,
    );
  }
}