import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/controller.dart';
import '../constants/effects.dart';

class Background extends StatelessWidget {
  Background({
    Key? key,
    required this.backgroundImage,
    required this.sensitivity,
    required this.blurValue,
    required this.blackValue,
  }) : super(key: key);

  final String backgroundImage;
  final int sensitivity;
  final double blurValue;
  final double blackValue;

  final controller = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedPositioned(
      duration:
          const Duration(milliseconds: Effects.animationDuration),
      top: Effects.accelerometerF(
          controller.accelerometerEvent.value.y, sensitivity),
      bottom: Effects.accelerometerR(
          controller.accelerometerEvent.value.y, sensitivity),
      right: Effects.accelerometerF(
          controller.accelerometerEvent.value.x, sensitivity),
      left: Effects.accelerometerR(
          controller.accelerometerEvent.value.x, sensitivity),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
          child: Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(blackValue)),
          ),
        ),
      ),
    ));
  }
}
