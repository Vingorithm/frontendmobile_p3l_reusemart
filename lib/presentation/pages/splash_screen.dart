// lib/presentation/pages/splash_screen.dart
import 'package:flutter/material.dart';
import '../../core/theme/color_pallete.dart';
import '../../utils/tokenUtils.dart';
import 'login_page.dart';
import 'home_page.dart';
import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _shimmerController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimationSequence();
  }

  void _initAnimations() {
    // Logo animations - simplified
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Text animations - simplified
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOut,
      ),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    // Shimmer effect - lightweight
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _shimmerController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _startAnimationSequence() async {
    // Start logo animation
    _logoController.forward();
    
    // Start text animation after logo
    await Future.delayed(const Duration(milliseconds: 400));
    _textController.forward();
    
    // Start shimmer effect
    await Future.delayed(const Duration(milliseconds: 600));
    _shimmerController.repeat(reverse: true);
    
    // Navigate after animations
    await Future.delayed(const Duration(milliseconds: 2500));
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const RootScreen();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2E7D32), // Dark Green
              Color(0xFF4CAF50), // Primary Green
              Color(0xFF66BB6A), // Light Green
            ],
          ),
        ),
        child: Stack(
          children: [
            // Subtle background pattern
            _buildBackgroundPattern(),
            
            // Main Content
            _buildMainContent(),
            
            // Skip Button
            _buildSkipButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: CustomPaint(
        painter: GreenPatternPainter(),
      ),
    );
  }

  Widget _buildMainContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Logo
          _buildAnimatedLogo(),
          
          const SizedBox(height: 48),
          
          // Animated Text Content
          _buildAnimatedTextContent(),
        ],
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Opacity(
            opacity: _logoOpacityAnimation.value,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback logo if image not found
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Reuse',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Mart',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedTextContent() {
    return SlideTransition(
      position: _textSlideAnimation,
      child: FadeTransition(
        opacity: _textOpacityAnimation,
        child: Column(
          children: [
            // App Name with shimmer effect
            AnimatedBuilder(
              animation: _shimmerAnimation,
              builder: (context, child) {
                return ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: const [
                        Colors.white70,
                        Colors.white,
                        Colors.white70,
                      ],
                      stops: [
                        0.0,
                        _shimmerAnimation.value.clamp(0.0, 1.0),
                        1.0,
                      ],
                    ).createShader(bounds);
                  },
                  child: const Text(
                    'ReuseMart',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // Tagline
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                'Berikan Kehidupan Baru pada Barang Bekas',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Simple loading dots
            _buildLoadingDots(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingDots() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final delay = index * 0.3;
            final animValue = (_shimmerAnimation.value + delay) % 2.0;
            final opacity = animValue > 1.0 ? 2.0 - animValue : animValue;
            
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(opacity.clamp(0.3, 1.0)),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildSkipButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      right: 20,
      child: FadeTransition(
        opacity: _textOpacityAnimation,
        child: TextButton(
          onPressed: _navigateToNextScreen,
          style: TextButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.2),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'Lewati',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter for subtle background pattern
class GreenPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    // Draw subtle circles
    for (int i = 0; i < 20; i++) {
      final double x = (i % 5) * (size.width / 4) + (size.width / 8);
      final double y = (i ~/ 5) * (size.height / 4) + (size.height / 8);
      final double radius = 30 + (i % 3) * 10;
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}