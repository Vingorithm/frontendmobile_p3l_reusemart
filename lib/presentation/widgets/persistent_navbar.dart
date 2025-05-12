import 'package:flutter/material.dart';
import '../../core/theme/color_pallete.dart';

class PersistentBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const PersistentBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<PersistentBottomNavBar> createState() => _PersistentBottomNavBarState();
}

class _PersistentBottomNavBarState extends State<PersistentBottomNavBar> with TickerProviderStateMixin {
  // Controllers for animations
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _bounceAnimations;
  
  // For indicator animation
  late AnimationController _indicatorAnimationController;
  late Animation<double> _indicatorAnimation;
  
  int _previousIndex = 0;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers for each nav item
    _animationControllers = List.generate(
      4,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      ),
    );
    
    // Scale animations for each item
    _scaleAnimations = _animationControllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeIn,
        ),
      );
    }).toList();
    
    // Bounce animations for each item
    _bounceAnimations = _animationControllers.map((controller) {
      return Tween<double>(begin: 0, end: -8).animate(
        CurvedAnimation(
          parent: controller,
          curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
          reverseCurve: Curves.easeInCubic,
        ),
      );
    }).toList();
    
    // For indicator animation
    _indicatorAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _indicatorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _indicatorAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Initialize with current selected index
    _previousIndex = widget.selectedIndex;
    _animationControllers[widget.selectedIndex].value = 1;
  }
  
  @override
  void didUpdateWidget(PersistentBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      // Reset previous animation
      _animationControllers[oldWidget.selectedIndex].reverse();
      
      // Start new animation
      _animationControllers[widget.selectedIndex].forward();
      
      // Update previous index for indicator animation
      _previousIndex = oldWidget.selectedIndex;
      
      // Restart indicator animation
      _indicatorAnimationController.reset();
      _indicatorAnimationController.forward();
    }
  }
  
  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    _indicatorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            // Animated indicator line
            AnimatedBuilder(
              animation: _indicatorAnimationController,
              builder: (context, child) {
                // Calculate position for animated indicator
                final double width = MediaQuery.of(context).size.width;
                final itemWidth = width / 4;
                
                final double startPosition = _previousIndex * itemWidth + (itemWidth / 2 - 15);
                final double endPosition = widget.selectedIndex * itemWidth + (itemWidth / 2 - 15);
                
                final double position = 
                    startPosition + (endPosition - startPosition) * _indicatorAnimation.value;
                    
                return Positioned(
                  top: 0,
                  left: position,
                  child: Container(
                    width: 30,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
            
            // Nav Items
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(0, Icons.shopping_bag_outlined, 'Produk'),
                  _buildNavItem(1, Icons.shopping_cart_outlined, 'Merchandise'),
                  _buildNavItem(2, Icons.assignment_outlined, 'Claim Merch'),
                  _buildNavItem(3, Icons.receipt_long_outlined, 'Transaksi'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = widget.selectedIndex == index;
    
    return AnimatedBuilder(
      animation: Listenable.merge([
        _scaleAnimations[index], 
        _bounceAnimations[index],
      ]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, isSelected ? _bounceAnimations[index].value : 0),
          child: InkWell(
            onTap: () {
              if (!isSelected) {
                widget.onItemSelected(index);
                _animationControllers[index].forward();
              }
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              width: 80,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.scale(
                    scale: isSelected ? _scaleAnimations[index].value : 1.0,
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: isSelected ? 28 : 24,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: isSelected ? 13 : 12,
                      color: Colors.white,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    child: Text(label),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}