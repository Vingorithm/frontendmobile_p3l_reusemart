// lib/presentation/widgets/nav_aware_scaffold.dart
import 'package:flutter/material.dart';
import 'navigation_helper.dart';
import 'persistent_navbar.dart';

/// Widget scaffold yang secara otomatis menampilkan persistent navbar
/// berdasarkan role pengguna dan pengaturan visibility
class NavAwareScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final bool showNavBar;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Widget? bottomSheet;
  final bool resizeToAvoidBottomInset;

  const NavAwareScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.showNavBar = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.bottomSheet,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: NavigationService.roleNotifier,
      builder: (context, role, _) {
        // Tentukan apakah navbar harus ditampilkan
        final shouldShowNavBar = showNavBar && 
                                role != "Guest" && 
                                role.isNotEmpty;

        return Scaffold(
          appBar: appBar,
          body: body,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          drawer: drawer,
          endDrawer: endDrawer,
          backgroundColor: backgroundColor,
          extendBody: extendBody,
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          bottomSheet: bottomSheet,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          bottomNavigationBar: shouldShowNavBar
              ? ValueListenableBuilder<int>(
                  valueListenable: NavigationService.selectedIndexNotifier,
                  builder: (context, selectedIndex, _) {
                    return PersistentBottomNavBar(
                      selectedIndex: selectedIndex,
                      onItemSelected: _onNavItemSelected,
                      role: role,
                    );
                  },
                )
              : null,
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
    // Import halaman-halaman yang diperlukan
    Widget destination;
    
    switch (route) {
      case '/home':
        // destination = const HomeScreen();
        destination = _createPlaceholderPage('Home');
        break;
      case '/merchandise':
        // destination = const MerchandiseScreen();
        destination = _createPlaceholderPage('Merchandise');
        break;
      case '/transaksi':
        final role = NavigationService.roleNotifier.value;
        if (role == 'Pembeli') {
          // destination = const HistoriPembelianPage();
          destination = _createPlaceholderPage('Histori Pembelian');
        } else if (role == 'Penitip') {
          // destination = const HistoriPenitipanPage();
          destination = _createPlaceholderPage('Histori Penitipan');
        } else {
          destination = _createPlaceholderPage('Transaksi');
        }
        break;
      case '/tugas':
        // destination = const HistoriTugasPage();
        destination = _createPlaceholderPage('Histori Tugas');
        break;
      case '/komisi':
        // destination = const HistoryKomisiDetailPage();
        destination = _createPlaceholderPage('Histori Komisi');
        break;
      case '/profile':
        // destination = const ProfileScreen();
        destination = _createPlaceholderPage('Profile');
        break;
      default:
        destination = _createPlaceholderPage('Home');
    }

    // Navigate dengan mengganti seluruh stack
    Navigator.of(NavigationService.navigatorKey.currentContext!)
        .pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => destination),
      (route) => false,
    );
  }

  // Placeholder page untuk testing
  Widget _createPlaceholderPage(String title) {
    return NavAwareScaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pages,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Halaman $title',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}