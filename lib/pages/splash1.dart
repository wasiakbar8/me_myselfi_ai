import 'package:flutter/material.dart';

class SplashScreen1 extends StatefulWidget {
  @override
  _SplashScreen1State createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Navigate to next screen after 30 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/splash2');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBCF),
      body: Stack(
        children: [
          // Centered Logo 1
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Hero(
                    tag: 'logo1_hero',
                    child: Image.asset(
                      'assets/logos/logo1.png',
                      width: 123,
                      height: 123,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
          ),
          // Positioned Logo 2 - 40px from bottom
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/logos/logo2.png',
                width: 183,
                height: 39,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
