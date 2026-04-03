import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class ConfettiOverlay extends StatefulWidget {
  const ConfettiOverlay({required this.child, super.key});

  final Widget child;

  static ConfettiOverlayState? of(BuildContext context) {
    return context.findAncestorStateOfType<ConfettiOverlayState>();
  }

  @override
  State<ConfettiOverlay> createState() => ConfettiOverlayState();
}

class ConfettiOverlayState extends State<ConfettiOverlay> {
  late final ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void celebrate() => _controller.play();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _controller,
            blastDirection: pi / 2,
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: 0.05,
            numberOfParticles: 25,
            maxBlastForce: 20,
            minBlastForce: 8,
            gravity: 0.3,
            colors: const [
              Color(0xFF6366F1),
              Color(0xFF22C55E),
              Color(0xFFF59E0B),
              Color(0xFF3B82F6),
              Color(0xFFEF4444),
              Color(0xFF818CF8),
            ],
          ),
        ),
      ],
    );
  }
}
