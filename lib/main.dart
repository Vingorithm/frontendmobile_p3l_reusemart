// lib/main.dart (Updated)
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontendmobile_p3l_reusemart/utils/notification_service.dart';
import 'core/theme/color_pallete.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/profile_page.dart';
import 'presentation/pages/merchandise_page.dart';
import 'presentation/pages/transaksi_page.dart';
import 'presentation/widgets/persistent_navbar.dart';
import 'presentation/pages/histori_komisi_page.dart';
import 'presentation/pages/histori_pembelian_page.dart';
import 'presentation/pages/histori_penitipan_page.dart';
import 'presentation/pages/histori_tugas_page.dart';
import 'presentation/pages/splash_screen.dart'; // Import splash screen
import 'utils/tokenUtils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationService.initializeNotification();
  FirebaseMessaging.onBackgroundMessage(
    NotificationService.firebaseMessagingBackgroundHandler,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MainApp());
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReuseMart',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          secondary: AppColors.secondary,
          background: AppColors.background,
          surface: AppColors.surface,
        ),
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      // Ubah home menjadi SplashScreen
      home: const SplashScreen(),
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  String role = "Guest";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getRoleFromToken();
  }

  Future<void> _getRoleFromToken() async {
    try {
      final token = await getToken();
      if (token != null) {
        final decoded = decodeToken(token);
        if (decoded != null && decoded.containsKey('role')) {
          setState(() {
            role = decoded['role'];
          });
        }
      }
    } catch (e) {
      // Handle error silently, default to Guest role
      setState(() {
        role = "Guest";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Widget> setScreens(String role) {
    switch (role) {
      case "Pembeli":
        return [
          const HomeScreen(),
          const MerchandiseScreen(),
          const HistoriPembelianPage(),
          const ProfileScreen(),
        ];
      case "Penitip":
        return [
          const HomeScreen(),
          const HistoriPenitipanPage(),
          const ProfileScreen(),
        ];
      case "Kurir":
        return [
          const HomeScreen(),
          const HistoriTugasPage(),
          const ProfileScreen(),
        ];
      case "Hunter":
        return [
          const HomeScreen(),
          const HistoryKomisiDetailPage(),
          const ProfileScreen(),
        ];
      case "Guest":
      default:
        return [
          const HomeScreen(),
          const ProfileScreen(), // Or a LoginScreen for guests
        ];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: setScreens(role),
      ),
      bottomNavigationBar: PersistentBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
        role: role,
      ),
    );
  }
}
