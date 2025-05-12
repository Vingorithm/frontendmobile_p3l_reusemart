import 'package:flutter/material.dart';
import '../../core/theme/color_pallete.dart';

class SearchBarWidget extends StatefulWidget {
  final String hintText;
  final Function(String)? onSearch;

  const SearchBarWidget({
    super.key,
    required this.hintText,
    this.onSearch,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  bool _isFocused = false;
  bool _showClearButton = false;
  
  @override
  void initState() {
    super.initState();
    
    // Setup animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    // Create pulse animation for search icon
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _animationController.repeat(reverse: true);
    
    // Add listener to show/hide clear button
    _controller.addListener(() {
      setState(() {
        _showClearButton = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(_isFocused ? 24 : 16),
        boxShadow: [
          BoxShadow(
            color: _isFocused 
                ? Colors.black.withOpacity(0.1)
                : Colors.transparent,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _isFocused ? AppColors.primary.withOpacity(0.5) : Colors.grey.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          ScaleTransition(
            scale: _isFocused ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
            child: Icon(
              Icons.search,
              color: _isFocused ? AppColors.primary : Colors.grey,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  _isFocused = hasFocus;
                });
              },
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                onSubmitted: widget.onSearch,
                textAlignVertical: TextAlignVertical.center,
                cursorColor: AppColors.primary,
                cursorWidth: 1.5,
                cursorRadius: const Radius.circular(4),
              ),
            ),
          ),
          
          // Clear button
          if (_showClearButton)
            GestureDetector(
              onTap: () {
                _controller.clear();
                if (widget.onSearch != null) {
                  widget.onSearch!('');
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          
          const SizedBox(width: 8),
          
          // Divider
          Container(
            height: 24,
            width: 1.5,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.15),
              borderRadius: BorderRadius.circular(1),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
          
          // Filter button
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                // Add filter functionality here
              },
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.tune,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Filter',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}