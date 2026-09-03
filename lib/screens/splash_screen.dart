import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _zoomOutController;
  late Animation<double> _zoomOutScale;
  late Animation<double> _zoomOutOpacity;
  String _dots = '';
  bool _zooming = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _zoomOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _zoomOutScale = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _zoomOutController, curve: Curves.easeInBack),
    );
    _zoomOutOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _zoomOutController, curve: Curves.easeIn),
    );

    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_dots.length >= 3) {
          _dots = '';
        } else {
          _dots += '.';
        }
      });
    });

    Timer(const Duration(seconds: 2), () {
      if (mounted && !_zooming) {
        _startZoomOut();
      }
    });
  }

  void _startZoomOut() {
    _zooming = true;
    _pulseController.stop();
    _zoomOutController.forward().then((_) {
      if (mounted) widget.onComplete();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _zoomOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      body: Center(
        child: AnimatedBuilder(
          animation: _zooming ? _zoomOutController : _pulseController,
          builder: (context, child) {
            final scale = _zooming ? _zoomOutScale.value : _pulseAnimation.value;
            final opacity = _zooming ? _zoomOutOpacity.value : 1.0;
            return Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo_rotina.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 24),
              const Text(
                'Rotina Comercial',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFE60014),
                  fontFamily: 'Open Sans',
                ),
              ),
              const SizedBox(height: 32),
              Text(
                _dots,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFE60014),
                  fontFamily: 'Open Sans',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
