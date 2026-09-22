import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLoadingIndicator extends StatefulWidget {
  final double dotSize;
  final Color color;

  const CustomLoadingIndicator({
    Key? key,
    this.dotSize = 8.0,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  _CustomLoadingIndicatorState createState() => _CustomLoadingIndicatorState();
}

class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.h,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              final progress = (_controller.value + index * 0.2) % 1.0;
              final scale = 0.5 + (0.5 * (1 - (progress - 0.5).abs() * 2));
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: widget.dotSize.w,
                    height: widget.dotSize.w,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
