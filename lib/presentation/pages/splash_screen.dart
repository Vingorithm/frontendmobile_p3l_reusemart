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
  late AnimationController _mainController;
  late AnimationController _logoController;
  late AnimationController _backgroundController;
  late AnimationController _particleController;

  // Main animations
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _taglineOpacityAnimation;
  late Animation<Offset> _taglineSlideAnimation;
  
  // Background animations
  late Animation<double> _backgroundOpacityAnimation;
  late Animation<double> _particleAnimation;
  
  // Shimmer effect
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimationSequence();
  }

  void _initAnimations() {
    // Main controller untuk sequence
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // Logo controller
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Background controller
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Particle controller
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    // Logo animations
    _logoScaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Text animations
    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.3, 0.7, curve: Curves.easeOutCubic),
    ));

    // Tagline animations
    _taglineOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.5, 0.9, curve: Curves.easeOut),
      ),
    );

    _taglineSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.5, 0.9, curve: Curves.easeOutCubic),
    ));

    // Background animation
    _backgroundOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.easeIn,
      ),
    );

    // Particle animation
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _particleController,
        curve: Curves.linear,
      ),
    );

    // Shimmer animation
    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  void _startAnimationSequence() async {
    // Start background animation first
    _backgroundController.forward();
    
    await Future.delayed(const Duration(milliseconds: 200));
    
    // Start particle animation
    _particleController.repeat();
    
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Start logo animation
    _logoController.forward();
    
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Start main animation sequence
    _mainController.forward();
    
    // Navigate after all animations
    await Future.delayed(const Duration(milliseconds: 3500));
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
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
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _logoController.dispose();
    _backgroundController.dispose();
    _particleController.dispose();
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2E7D32), // Dark Green
              Color(0xFF4CAF50), // Primary Green - selaras dengan home
              Color(0xFF66BB6A), // Light Green
              Color(0xFF81C784), // Very Light Green
            ],
            stops: [0.0, 0.4, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background pattern
            _buildAnimatedBackground(),
            
            // Floating particles
            _buildFloatingParticles(),
            
            // Main content
            _buildMainContent(),
            
            // Skip button
            _buildSkipButton(),
            
            // Bottom brand info
            _buildBottomBrandInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Positioned.fill(
          child: Opacity(
            opacity: _backgroundOpacityAnimation.value,
            child: CustomPaint(
              painter: EnhancedBackgroundPainter(
                animationValue: _particleAnimation.value,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingParticles() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(
            painter: FloatingParticlesPainter(
              animationValue: _particleAnimation.value,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Logo - tanpa card wrapper
          _buildEnhancedLogo(),
          
          const SizedBox(height: 64),
          
          // App Name dengan shimmer effect
          _buildAnimatedAppName(),
          
          const SizedBox(height: 24),
          
          // Tagline
          _buildAnimatedTagline(),
          
          const SizedBox(height: 60),
          
          // Loading indicator
          _buildEnhancedLoadingIndicator(),
        ],
      ),
    );
  }

  Widget _buildEnhancedLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoController, _mainController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Opacity(
            opacity: _logoOpacityAnimation.value,
            child: Container(
              // Tidak ada background card, logo langsung ditampilkan
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Glow effect di belakang logo
                  Container(
                    width: 200,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                        BoxShadow(
                          color: const Color(0xFF4CAF50).withOpacity(0.2),
                          blurRadius: 50,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  // Logo utama
                  Container(
                    width: 330, // Disesuaikan dengan rasio 426:105
                    height: 150,  // Maintain aspect ratio
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildFallbackLogo();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFallbackLogo() {
    return Container(
      width: 180,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Reuse',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2E7D32),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Mart',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedAppName() {
    return SlideTransition(
      position: _textSlideAnimation,
      child: FadeTransition(
        opacity: _textOpacityAnimation,
        child: AnimatedBuilder(
          animation: _shimmerAnimation,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: const [
                    Colors.white60,
                    Colors.white,
                    Colors.white,
                    Colors.white60,
                  ],
                  stops: [
                    0.0,
                    (_shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                    (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
                    1.0,
                  ],
                ).createShader(bounds);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedTagline() {
    return SlideTransition(
      position: _taglineSlideAnimation,
      child: FadeTransition(
        opacity: _taglineOpacityAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Berikan Kehidupan Baru',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'pada Barang Bekas',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Kualitas Terbaik • QC Terjamin',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedLoadingIndicator() {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return Opacity(
          opacity: _textOpacityAnimation.value,
          child: Column(
            children: [
              // Circular progress indicator dengan style yang selaras
              Container(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withOpacity(0.8),
                  ),
                  backgroundColor: Colors.white.withOpacity(0.2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Menyiapkan pengalaman terbaik...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSkipButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      right: 20,
      child: AnimatedBuilder(
        animation: _textOpacityAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _textOpacityAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: TextButton(
                onPressed: _navigateToNextScreen,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Lewati',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomBrandInfo() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _taglineOpacityAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _taglineOpacityAnimation.value,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      color: Colors.white.withOpacity(0.7),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Terpercaya & Berkualitas',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Enhanced background painter dengan pattern yang lebih menarik
class EnhancedBackgroundPainter extends CustomPainter {
  final double animationValue;

  EnhancedBackgroundPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    // Create organic shapes
    for (int i = 0; i < 15; i++) {
      final double progress = (animationValue + i * 0.1) % 1.0;
      final double x = (i % 4) * (size.width / 3) + (size.width / 6);
      final double y = (i ~/ 4) * (size.height / 4) + 
                     (size.height / 8) + 
                     (progress * 50 - 25);
      final double radius = 25 + (i % 3) * 15 + (progress * 10);
      
      paint.color = Colors.white.withOpacity(0.02 + progress * 0.03);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(EnhancedBackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

// Floating particles painter
class FloatingParticlesPainter extends CustomPainter {
  final double animationValue;

  FloatingParticlesPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Create floating particles
    for (int i = 0; i < 25; i++) {
      final double progress = (animationValue * 0.5 + i * 0.04) % 1.0;
      final double x = (i * 17) % size.width;
      final double y = size.height * progress;
      final double opacity = (1 - progress) * 0.6;
      final double radius = 1.5 + (i % 3);
      
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(FloatingParticlesPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}