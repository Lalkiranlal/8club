import 'package:flutter/material.dart';
import 'package:test/assets/colors/colors.dart';
import 'package:test/assets/fonts/fonts.dart';

class NextButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;

  const NextButton({
    super.key,
    this.onPressed,
    this.text = 'Next',
  });

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutBack,
      ),
    );
    // Add opacity animation
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (widget.onPressed != null) {
          _animationController.forward();
        }
      },
      onExit: (_) {
        if (widget.onPressed != null) {
          _animationController.reverse();
        }
      },
      child: GestureDetector(
        onTapDown: (_) {
          if (widget.onPressed != null) {
            _animationController.forward();
          }
        },
        onTapUp: (_) {
          if (widget.onPressed != null) {
            _animationController.reverse();
            widget.onPressed!();
          }
        },
        onTapCancel: () {
          if (widget.onPressed != null) {
            _animationController.reverse();
          }
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: widget.onPressed != null
                        ? const LinearGradient(
                            colors: [Color(0xFF101010), Color(0xFFFFFFFF)],
                            stops: [0.0, 1.0],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        : const LinearGradient(
                            colors: [
                              Color(0xFF101010),
                              Color(0xFF222222),
                              Color(0xFF101010),
                            ],
                            stops: [0.0, 0.5, 1.0],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: widget.onPressed != null
                          ? const Color(0xFF999999)
                          : const Color(0xFF222222),
                      width: 1.0,
                    ),
                    boxShadow: [
                      if (_animationController.status == AnimationStatus.forward)
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                child: TextButton(
                  onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor:
              widget.onPressed != null
                        ? AppColors.text1
                        : const Color(0xFF999999),
                    shape: RoundedRectangleBorder(
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    minimumSize: const Size.fromHeight(56),
                    shadowColor: Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [ 

                      Text(
                        widget.text,
                        style: AppTextStyles.b1Bold.copyWith(
                          color: widget.onPressed != null
                              ? null
                              : const Color(0xFF999999),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 24,
                        color: widget.onPressed != null
                            ? AppColors.text1
                            : const Color(0xFF999999),
                      ),
                    ],
                  ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
