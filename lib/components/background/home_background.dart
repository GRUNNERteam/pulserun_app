import 'package:flutter/material.dart';

class BackgroundHomePage extends StatefulWidget {
  final double height;

  BackgroundHomePage(this.height);

  @override
  _BackgroundHomePageState createState() => _BackgroundHomePageState();
}

class _BackgroundHomePageState extends State<BackgroundHomePage>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;
  final double startingHeight = 20.0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    animation = Tween<double>(begin: startingHeight, end: widget.height)
        .animate(_controller);
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        builder: (context, anim) {
          return ClipPath(
            clipper: RoundedClipper(animation.value),
            child: Container(
              height: animation.value,
              color: Theme.of(context).primaryColor,
            ),
          );
        },
        animation: _controller,
      ),
    );
  }
}

class RoundedClipper extends CustomClipper<Path> {
  final double height;

  RoundedClipper(this.height);

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, height - 200);
    path.quadraticBezierTo(
      size.width / 2,
      height,
      size.width,
      height - 200,
    );
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
