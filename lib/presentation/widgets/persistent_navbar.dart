import 'package:flutter/material.dart';
import '../../core/theme/color_pallete.dart';

class PersistentBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final String role; // Tambahan role

  const PersistentBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.role,
  });

  @override
  State<PersistentBottomNavBar> createState() => _PersistentBottomNavBarState();
}

class _PersistentBottomNavBarState extends State<PersistentBottomNavBar> with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _bounceAnimations;

  late AnimationController _indicatorAnimationController;
  late Animation<double> _indicatorAnimation;

  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();

    final itemCount = _buildNavItemsByRole().length;

    _animationControllers = List.generate(
      itemCount,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      ),
    );

    _scaleAnimations = _animationControllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeIn,
        ),
      );
    }).toList();

    _bounceAnimations = _animationControllers.map((controller) {
      return Tween<double>(begin: 0, end: -8).animate(
        CurvedAnimation(
          parent: controller,
          curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
          reverseCurve: Curves.easeInCubic,
        ),
      );
    }).toList();

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

    _previousIndex = widget.selectedIndex;
    _animationControllers[widget.selectedIndex].value = 1;
  }

  @override
  void didUpdateWidget(PersistentBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _animationControllers[oldWidget.selectedIndex].reverse();
      _animationControllers[widget.selectedIndex].forward();

      _previousIndex = oldWidget.selectedIndex;
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

  List<Map<String, dynamic>> _buildNavItemsByRole() {
    switch (widget.role) {
      case 'Pembeli':
        return [
          {'icon': Icons.home_outlined, 'label': 'Home'},
          {'icon': Icons.shopping_cart_outlined, 'label': 'Merchandise'},
          {'icon': Icons.receipt_long_outlined, 'label': 'Transaksi'},
          {'icon': Icons.person_outline, 'label': 'Profile'},
        ];
      case 'Penitip':
        return [
          {'icon': Icons.home_outlined, 'label': 'Home'},
          {'icon': Icons.receipt_long_outlined, 'label': 'Transaksi'},
          {'icon': Icons.person_outline, 'label': 'Profile'},
        ];
      case 'Kurir':
        return [
          {'icon': Icons.home_outlined, 'label': 'Home'},
          {'icon': Icons.task_alt_outlined, 'label': 'Tugas'},
          {'icon': Icons.person_outline, 'label': 'Profile'},
        ];
      case 'Hunter':
        return [
          {'icon': Icons.home_outlined, 'label': 'Home'},
          {'icon': Icons.attach_money_outlined, 'label': 'Komisi'},
          {'icon': Icons.person_outline, 'label': 'Profile'},
        ];
      default:
        return [
          {'icon': Icons.home_outlined, 'label': 'Home'},
          {'icon': Icons.person_outline, 'label': 'Profile'},
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _buildNavItemsByRole();

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
            AnimatedBuilder(
              animation: _indicatorAnimationController,
              builder: (context, child) {
                final double width = MediaQuery.of(context).size.width;
                final itemWidth = width / items.length;

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

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(items.length, (index) {
                  return _buildNavItem(index, items[index]['icon'], items[index]['label']);
                }),
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
