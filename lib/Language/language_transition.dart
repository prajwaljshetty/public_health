import 'dart:ui';

import 'package:flutter/cupertino.dart';

class LanguageTransition extends StatefulWidget {
  final Widget child;

  const LanguageTransition({super.key, required this.child});

  @override
  State<LanguageTransition> createState() => _LanguageTransitionState();
}

class _LanguageTransitionState extends State<LanguageTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      value: 1,
    );
  }

  @override
  void didUpdateWidget(covariant LanguageTransition oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.child != widget.child) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final value = Curves.easeOut.transform(_controller.value);

        final blur = 5.0 * (1.0 - value);

        return Opacity(
          opacity: value,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: child,
          ),
        );
      },
    );
  }
}
