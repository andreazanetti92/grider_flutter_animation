import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/cat.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  late Animation<double> catAnimation;
  late AnimationController catController;
  late Animation<double> boxFlapsAnimation;
  late AnimationController boxFlapsController;

  @override
  void initState() {
    super.initState();

    boxFlapsController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    boxFlapsAnimation = Tween(begin: pi * 0.1, end: pi * 0.15).animate(
        CurvedAnimation(parent: boxFlapsController, curve: Curves.easeInOut));
    boxFlapsAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        boxFlapsController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxFlapsController.forward();
      }
    });
    boxFlapsController.forward();

    catController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    catAnimation = Tween(begin: -40.0, end: -83.0)
        .animate(CurvedAnimation(parent: catController, curve: Curves.easeIn));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Animation"),
        ),
        body: GestureDetector(
            onTap: onTap,
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  buildCatAnimation(),
                  buildBox(),
                  buildLeftFlap(),
                  buildRightFlap(),
                ],
              ),
            )));
  }

  onTap() {
    if (catController.status == AnimationStatus.completed) {
      catController.reverse();
      boxFlapsController.forward();
    } else if (catController.status == AnimationStatus.dismissed) {
      catController.forward();
      boxFlapsController.stop();
    }
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
          top: catAnimation.value,
          right: 0,
          left: 0,
          child: child!,
        );
      },
      child: Cat(),
    );
  }

  Widget buildBox() {
    return Container(
      height: 200.0,
      width: 200.0,
      color: const Color(0xFFB29084),
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
        left: -8.0,
        top: 0.0,
        child: AnimatedBuilder(
          animation: boxFlapsAnimation,
          builder: ((context, child) {
            return Transform.rotate(
              angle: boxFlapsAnimation.value,
              alignment: Alignment.topRight,
              child: child,
            );
          }),
          child: Container(
            width: 10.0,
            height: 125.0,
            color: const Color(0xFFB29084),
          ),
        ));
  }

  Widget buildRightFlap() {
    return Positioned(
        right: -8.0,
        top: 0.0,
        child: AnimatedBuilder(
          animation: boxFlapsAnimation,
          builder: ((context, child) {
            return Transform.rotate(
              angle: -boxFlapsAnimation.value,
              alignment: Alignment.topLeft,
              child: child,
            );
          }),
          child: Container(
            width: 10.0,
            height: 125.0,
            color: const Color(0xFFB29084),
          ),
        ));
  }
}
