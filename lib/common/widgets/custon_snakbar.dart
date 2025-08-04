import 'package:blood_donor/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;

import 'package:sizer/sizer.dart';

void showCustomSnackBar(
  BuildContext context, {
  required String message,
  Color? color,
}) {
  // Validate the overlay exists
  final overlay = Overlay.of(navigatorKey.currentContext!);
  // if (overlay == null) {
  //   debugPrint('No Overlay widget found in the current context.');
  //   return;
  // }

  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 20.0,
      left: 20.0,
      right: 20.0,
      child: Material(
        color: Colors.transparent,
        child: SlideTransitionSnackBar(
          message: message,
          color: color ?? Colors.teal,
        ),
      ),
    ),
  );

  // Insert the overlay entry
  overlay.insert(overlayEntry);

  // Remove after duration
  Future.delayed(const Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}

class SlideTransitionSnackBar extends StatefulWidget {
  final String message;
  final Color color;

  const SlideTransitionSnackBar({
    Key? key,
    required this.message,
    required this.color,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SlideTransitionSnackBarState createState() =>
      _SlideTransitionSnackBarState();
}

class _SlideTransitionSnackBarState extends State<SlideTransitionSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Text(
                  widget.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
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
}

class CustomEasypaisaLoader extends StatefulWidget {
  @override
  _CustomEasypaisaLoaderState createState() => _CustomEasypaisaLoaderState();
}

class _CustomEasypaisaLoaderState extends State<CustomEasypaisaLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dimmed background
        Opacity(
          opacity: 0.5,
          child: const ModalBarrier(dismissible: false, color: Colors.black),
        ),
        Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * math.pi,
                child: child,
              );
            },
            child: Container(
                width: 100,
                height: 100,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
                ),
                child: SvgPicture.asset(
                  'images/svg/Logo.svg',
                  height: 5.h,
                  width: 5.w,
                )),
          ),
        ),
      ],
    );
  }
}

void showCustomLoader(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => CustomEasypaisaLoader(),
  );
}
