import 'package:flutter/cupertino.dart';

class AnimatedHeroStack extends StatefulWidget {
  const AnimatedHeroStack({super.key});

  @override
  _AnimatedHeroStackState createState() => _AnimatedHeroStackState();
}

class _AnimatedHeroStackState extends State<AnimatedHeroStack> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _opacityAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(-300, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
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
         Positioned(
          child: FadeTransition(
            opacity: _opacityAnim,
            child: Transform.translate(
              offset: const Offset(-100, 0),
              child: Image.asset(
                'assets/login/vector_bg.png',
                height: 450,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedBuilder(
            animation: _slideAnim,
            builder: (context, child) {
              return Transform.translate(
                offset: _slideAnim.value,
                child: child,
              );
            },
            child: Image.asset(
              'assets/login/hero_illustrations.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

