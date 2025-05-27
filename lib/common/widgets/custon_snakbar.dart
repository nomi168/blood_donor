import 'package:blood_donor/main.dart';
import 'package:flutter/material.dart';

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
