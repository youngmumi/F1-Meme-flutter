import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hilarious F1 Meme App',
      theme: ThemeData.dark(),
      home: MemeScreen(),
    );
  }
}

class MemeScreen extends StatefulWidget {
  @override
  _MemeScreenState createState() => _MemeScreenState();
}

class _MemeScreenState extends State<MemeScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _shakeController;
  late AnimationController _carController;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    _shakeController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _carController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this)
      ..repeat();

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _shakeController.dispose();
    _carController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.red, Colors.black],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Column(
                    children: [
                      _buildAnimatedText('YOU GOT A PROBLEM?', 0.0, 0.2),
                      SizedBox(height: 20),
                      _buildAnimatedText('CHANGE YOUR', 0.2, 0.4),
                      SizedBox(height: 20),
                      _buildAnimatedText('F**KING CAR!', 0.4, 0.6),
                      SizedBox(height: 40),
                      _buildAnimatedCar(),
                    ],
                  );
                },
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _restartAnimation,
                child: Text('REPLAY',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.yellow,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedText(String text, double begin, double end) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(begin, end, curve: Curves.elasticOut),
        ),
      ),
      child: ShakeWidget(
        animation: _shakeController,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.yellow,
            shadows: [
              Shadow(color: Colors.red, offset: Offset(2, 2), blurRadius: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCar() {
    return AnimatedBuilder(
      animation: _carController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(100 * math.sin(_carController.value * math.pi * 2), 0),
          child: Transform.rotate(
            angle: _carController.value * math.pi,
            child: Text('🏎️', style: TextStyle(fontSize: 80)),
          ),
        );
      },
    );
  }

  void _restartAnimation() {
    _controller.reset();
    _controller.forward();
    _shakeController.repeat(reverse: true);
    Future.delayed(Duration(milliseconds: 500), () {
      _shakeController.stop();
    });
  }
}

class ShakeWidget extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;

  ShakeWidget({required this.child, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(math.sin(animation.value * math.pi * 10) * 10, 0),
          child: child,
        );
      },
      child: child,
    );
  }
}
