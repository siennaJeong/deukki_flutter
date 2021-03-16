
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class RippleAnimation extends StatefulWidget {
  const RippleAnimation({
    this.color,
    this.rippleTarget,
    this.controller,
    this.radius
  });

  final Color color;
  final Widget rippleTarget;
  final AnimationController controller;
  final double radius;

  @override
  _RippleAnimationState createState() => _RippleAnimationState();
}

class _RippleAnimationState extends State<RippleAnimation> {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _animation = Tween(begin: 0.0, end: 6.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Ink(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(widget.radius),
            boxShadow: [
              for(int i = 0 ; i <= 2 ; i++)
                BoxShadow(
                  color: widget.color.withOpacity(_controller.value / 3),
                  spreadRadius: _animation.value,
                  blurRadius: _animation.value
                )
            ]
          ),
          child: widget.rippleTarget,
        );
      }
    );
  }
}
